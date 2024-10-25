package com.med3dexplorer.utils;


import org.modelmapper.ModelMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

@Component
public class ModelMapperConfig {


    @Bean
    public ModelMapper modelMapper() {
        return new ModelMapper();
    }
}
