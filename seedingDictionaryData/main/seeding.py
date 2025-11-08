import csv
import requests
import time
import json
import sys
import argparse
import logging

# --- Cau hinh ---
CSV_FILE = '../data_csv/words_unique.csv'
API_BASE_URL = 'http://localhost:8080'

API_TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8va2lldXR1bmctbm9zLmNvbSIsInN1YiI6IjVjMjgzYmI4LTMwMGQtNGFjYy1hNTJlLTAyNWY3NzIzZTVkZCIsInJvbGUiOiJBRE1JTiIsImV4cCI6MTc2MjY3ODQ3MSwiaWF0IjoxNzYyMTYwMDcxLCJlbWFpbCI6ImtpZXV0dW5nQGFkbWluLmNvbSJ9.f4DD4_3YBNd8S_BHkhj2sNnSo17TUBHEsCL2A2AC3dE" 

ADD_WORD_ENDPOINT = f'{API_BASE_URL}/seeding/add-word'
RUN_ENDPOINT = f'{API_BASE_URL}/seeding/run'
BATCH_SIZE = 25
DELAY_SECONDS = 60
ADD_WORD_DELAY_MS = 0.1

headers = {
    "Authorization": f"Bearer {API_TOKEN}",
    "Content-Type": "application/json"
}

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def read_words_from_csv(filepath):
    words = []
    try:
        with open(filepath, mode='r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            for row in reader:
                words.append({
                    "word": row["word"],
                    "wordClass": row["class"],
                    "level": row["level"]
                })
        return words
    except FileNotFoundError:
        logging.error(f"Loi: Khong tim thay file '{filepath}'.")
        sys.exit(1)
    except Exception as e:
        logging.error(f"Loi khi doc file CSV: {e}")
        sys.exit(1)

def run_seeder(start_index):
    all_words = read_words_from_csv(CSV_FILE)
    total_words = len(all_words)
    
    if start_index >= total_words:
        logging.info("Index bat dau lon hon tong so tu. Khong co gi de seeding.")
        return

    logging.info(f"Tong so tu doc duoc: {total_words}")
    logging.info(f"Bat dau seeding tu index: {start_index} (Batch size: {BATCH_SIZE}, Delay: {DELAY_SECONDS}s)")

    for i in range(start_index, total_words, BATCH_SIZE):
        batch = all_words[i : i + BATCH_SIZE]
        if not batch:
            break

        current_batch_info = f"Batch tu index {i} den {min(i + BATCH_SIZE - 1, total_words - 1)}"
        logging.info(f"--- Dang xu ly {current_batch_info} ---")

        logging.info(f"Dang goi POST /seeding/add-word (1-by-1) cho {len(batch)} tu...")
        
        current_global_index = i 
        
        try:
            for word_index_in_batch, word_data in enumerate(batch):
                current_global_index = i + word_index_in_batch
                
                payload = {"newWord": word_data["word"]}
                
                response = requests.post(
                    ADD_WORD_ENDPOINT, 
                    data=json.dumps(payload), 
                    headers=headers
                )
                
                response.raise_for_status() 
                
                time.sleep(ADD_WORD_DELAY_MS)
            
            logging.info(f"Them {len(batch)} tu (1-by-1) thanh cong.")

        except requests.exceptions.RequestException as e:
            word_data = all_words[current_global_index] 
            logging.error(f"\n!!! LOI KHI GOI /add-word TAI INDEX {current_global_index} (Tu: '{word_data.get('word')}') !!!")
            logging.error(f"Ly do: {e}")
            logging.error(f"--> LAN CHAY TOI, HAY BAT DAU LAI TU INDEX: {current_global_index} <--")
            sys.exit(1)

        try:
            logging.info("Dang goi POST /seeding/run de xu ly cac tu 'PENDING'...")
            response = requests.post(RUN_ENDPOINT, headers=headers) 
            
            response.raise_for_status()
            
            logging.info(f"Xu ly 'run' thanh cong. Response: {response.text}")

        except requests.exceptions.RequestException as e:
            logging.error(f"\n!!! LOI KHI GOI /run TAI BATCH {i} !!!")
            logging.error(f"Cac tu da duoc them, nhung chua duoc xu ly.")
            logging.error(f"Ly do: {e}")
            logging.error(f"--> LAN CHAY TOI, HAY BAT DAU LAI TU INDEX: {i} (De them lai va xu ly) <--")
            logging.error("Hoac ban co the goi /run thu cong truoc khi chay lai script.")
            sys.exit(1)

        if (i + BATCH_SIZE) < total_words:
            logging.info(f"Xu ly batch {i} thanh cong. Dang cho {DELAY_SECONDS} giay truoc khi tiep tuc...")
            time.sleep(DELAY_SECONDS)
        else:
            logging.info("Da xu ly batch cuoi cung.")

    logging.info("--- HOAN THANH! Tat ca cac tu da duoc seeding. ---")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Script de seeding tu vung vao database qua API.")
    parser.add_argument(
        '--start-index', 
        type=int, 
        default=0, 
        help='Index (vi tri) bat dau de seeding (vi du: 0, 30, 60...).'
    )
    
    args = parser.parse_args()
    
    run_seeder(args.start_index)


