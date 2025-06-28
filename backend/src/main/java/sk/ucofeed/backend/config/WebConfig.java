package sk.ucofeed.backend.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Value("${frontend.public.url}")
    private String publicFrontendUrl;

    @Value("${frontend.private.url}")
    private String privateFrontendUrl;

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/public/**")
                .allowedOrigins(publicFrontendUrl)
                .allowedMethods("GET", "POST", "PUT", "DELETE");

        registry.addMapping("/api/private/**")
                .allowedOrigins(privateFrontendUrl)
                .allowedMethods("GET", "POST", "PUT", "DELETE");
    }
}
