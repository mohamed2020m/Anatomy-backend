import { Quiz } from "../constants/data"
import { Session } from "../types/next-auth"
import getServerSession from 'next-auth';
import authConfig from '../auth.config';

const API_URL = `${process.env.NEXT_PUBLIC_BACKEND_API}/api/v1`

// Get the session
const getSessionToken = async () => {
    const session = await getServerSession(authConfig);
    const auth : Session = await session.auth();
    
    return auth.user.access_token;
}

// Fetch all quizzes
export const fetchQuizzes = async (): Promise<Quiz[]> => {
    const token = await getSessionToken();
    console.log('jwt token', token);
    
    const headers = {
        Authorization: `Bearer ${token}`, 
       'Content-Type': 'application/json'
    }
    console.log('headers', headers);

    const response = await fetch(`${API_URL}/quizzes`, {
        method: 'GET',
        headers: headers
    });

    if (!response.ok) {
        throw new Error('Failed to fetch quizzes');
    }

    return await response.json();
};


export const fetchQuizzesByID = async (): Promise<Quiz[]> => {
    const token = await getSessionToken();
        
    const headers = {
        Authorization: `Bearer ${token}`, 
       'Content-Type': 'application/json'
    }
    console.log('headers', headers);

    const response = await fetch(`${API_URL}/quizzes`, {
        method: 'GET',
        headers: headers
    });

    if (!response.ok) {
        throw new Error('Failed to fetch quizzes');
    }

    return await response.json();
};


export const quizzesService = {
    records: [] as Quiz[], // Holds the list of quiz objects

    // Initialize with fetched data
    async initialize() {
        this.records = await fetchQuizzes(); // Fetch quizzes from API
    },

    // Get all quizzes with optional search
    async getAll({ search }: { search?: string }) {
        let quizzes = [...this.records];

        // Search functionality across multiple fields
        if (search) {
            quizzes = quizzes.filter(quiz =>
                quiz.title.toLowerCase().includes(search.toLowerCase()) ||
                quiz.description.toLowerCase().includes(search.toLowerCase())
            );
        }
        return quizzes;
    },

    // Get paginated results with optional search
    async getQuizzes({
        page = 1,
        limit = 10,
        search
    }: {
        page?: number;
        limit?: number;
        search?: string;
    }) {
        const allQuizzes = await this.getAll({ search });
        const totalQuizzes = allQuizzes.length;

        // Pagination logic
        const offset = (page - 1) * limit;
        const paginatedQuizzes = allQuizzes.slice(offset, offset + limit);

        // Return paginated response
        return {
            success: true,
            total_quizzes: totalQuizzes,
            offset,
            limit,
            quizzes: paginatedQuizzes
        };
    }
};

quizzesService.initialize();

