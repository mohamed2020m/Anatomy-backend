package com.med3dexplorer.exceptions;

public class FavouriteNotFoundException extends RuntimeException {
    public FavouriteNotFoundException(String message) {
        super(message);
    }
}
