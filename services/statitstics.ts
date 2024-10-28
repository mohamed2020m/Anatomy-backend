import { Session } from "../types/next-auth";
import getServerSession from 'next-auth';
import authConfig from '../auth.config';

//const API_URL = `${process.env.BACKEND_API}/api/v1`;
const API_URL = 'http://localhost:8080/api/v1';

// Get the session token
const getSessionToken = async () => {
    const session = await getServerSession(authConfig);
    const auth : Session = await session.auth();
    
    return auth.user.access_token;
}

// Fetch professor count
export const fetchProfessorsCount = async (): Promise<number> => {
    const token = await getSessionToken();
    
    const headers = {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json'
    };

    const response = await fetch(`${API_URL}/professors/count`, {
        method: 'GET',
        headers: headers
    });

    // Log the response for debugging
    console.log('Response status:', response.status);
    console.log('Response headers:', response.headers);
    
    if (!response.ok) {
        const errorText = await response.text(); // Get additional error info
        console.error('Fetch error:', errorText);
        throw new Error('Failed to fetch professors count: ' + errorText);
    }

    return await response.json();
};

export const statisticsService = {
    fetchProfessorsCount
};