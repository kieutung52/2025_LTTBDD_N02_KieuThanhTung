import csv
import logging
import os

# --- Cau hinh ---
INPUT_CSV = '../data_csv/oxford-5000.csv'
OUTPUT_CSV = '../data_csv/words_unique.csv'
COLUMN_TO_CHECK = 'word'

# Thiet lap logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def create_unique_csv():
    seen_words = set()
    total_rows_read = 0
    total_rows_written = 0
    
    if not os.path.exists(INPUT_CSV):
        logging.error(f"Loi: Khong tim thay file dau vao '{INPUT_CSV}'. Vui long kiem tra lai.")
        return

    try:
        with open(INPUT_CSV, mode='r', encoding='utf-8-sig') as infile, \
             open(OUTPUT_CSV, mode='w', encoding='utf-8', newline='') as outfile:
            
            reader = csv.DictReader(infile)
            
            fieldnames = reader.fieldnames
            if fieldnames is None:
                logging.error(f"Loi: File CSV dau vao '{INPUT_CSV}' trong hoac khong co header.")
                return

            if COLUMN_TO_CHECK not in fieldnames:
                logging.error(f"Loi: Khong tim thay cot '{COLUMN_TO_CHECK}' trong file '{INPUT_CSV}'.")
                logging.error(f"Cac cot tim thay: {fieldnames}")
                return

            writer = csv.DictWriter(outfile, fieldnames=fieldnames)
            writer.writeheader()
            
            for row in reader:
                total_rows_read += 1
                
                word = row.get(COLUMN_TO_CHECK)
                if word is None or word.strip() == '':
                    logging.warning(f"Hang {total_rows_read + 1} bi bo qua vi gia tri cot '{COLUMN_TO_CHECK}' bi trong.")
                    continue

                word_lower = word.lower() 

                if word_lower not in seen_words:
                    seen_words.add(word_lower)
                    writer.writerow(row)
                    total_rows_written += 1
                else:
                    logging.info(f"Bo qua tu trung lap: '{word}'")
                    pass
            
            logging.info(f"--- HOAN THANH ---")
            logging.info(f"Da doc tong cong: {total_rows_read} hang tu '{INPUT_CSV}'.")
            logging.info(f"Da loc va ghi: {total_rows_written} tu duy nhat vao '{OUTPUT_CSV}'.")

    except Exception as e:
        logging.error(f"Da co loi xay ra trong qua trinh xu ly: {e}")

if __name__ == "__main__":
    logging.info(f"Bat dau qua trinh tien xu ly de tao file CSV duy nhat...")
    logging.info(f"File dau vao: {INPUT_CSV}")
    logging.info(f"File dau ra: {OUTPUT_CSV}")
    logging.info(f"Cot kiem tra duy nhat: {COLUMN_TO_CHECK}")
    create_unique_csv()
