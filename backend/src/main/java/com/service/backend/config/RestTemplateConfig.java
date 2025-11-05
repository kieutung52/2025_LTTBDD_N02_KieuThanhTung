package com.service.backend.config;

import org.apache.hc.client5.http.config.ConnectionConfig; // <-- THÊM IMPORT
import org.apache.hc.client5.http.config.RequestConfig;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.client5.http.impl.io.PoolingHttpClientConnectionManager;
import org.apache.hc.core5.util.Timeout; // <-- THÊM IMPORT
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

import java.util.concurrent.TimeUnit;

@Configuration
public class RestTemplateConfig {

    private static final int CONNECT_TIMEOUT_MS = 5000;
    private static final int CONNECTION_REQUEST_TIMEOUT_MS = 5000;
    private static final int RESPONSE_TIMEOUT_MS = 600000;

    @Bean
    public RestTemplate restTemplate() {
        final ConnectionConfig connectionConfig = ConnectionConfig.custom()
                .setConnectTimeout(CONNECT_TIMEOUT_MS, TimeUnit.MILLISECONDS)
                .build();

        final PoolingHttpClientConnectionManager connectionManager = new PoolingHttpClientConnectionManager();
        connectionManager.setMaxTotal(100);
        connectionManager.setDefaultMaxPerRoute(20);
        connectionManager.setDefaultConnectionConfig(connectionConfig); // <-- ÁP DỤNG Ở ĐÂY

        final RequestConfig requestConfig = RequestConfig.custom()
                .setConnectionRequestTimeout(Timeout.ofMilliseconds(CONNECTION_REQUEST_TIMEOUT_MS))
                .setResponseTimeout(Timeout.ofMilliseconds(RESPONSE_TIMEOUT_MS))
                .build();

        final CloseableHttpClient httpClient = HttpClients.custom()
                .setConnectionManager(connectionManager)
                .setDefaultRequestConfig(requestConfig)
                .build();

        final HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory(httpClient);
        
        return new RestTemplate(factory);
    }
}