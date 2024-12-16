import { Professor } from "../constants/data"
import { Session } from "../types/next-auth"
import getServerSession from 'next-auth';
import authConfig from '../auth.config';

const API_URL = `${process.env.BACKEND_API}/api/v1`

// Get the session
const getSessionToken = async () => {
    const session = await getServerSession(authConfig);
    const auth : Session = await session.auth();
    
    return auth.user.access_token;
}

// Fetch all professors
export const fetchProfessors = async (): Promise<Professor[]> => {
    const token = await getSessionToken();
    console.log('jwt token', token);
    
    const headers = {
        Authorization: `Bearer ${token}`, 
       'Content-Type': 'application/json'
    }
    console.log('headers', headers);

    const response = await fetch(`${API_URL}/professors`, {
        method: 'GET',
        headers: headers
    });

    if (!response.ok) {
        throw new Error('Failed to fetch professors');
    }

    return await response.json();
};


export const fetchProfessorsByID = async (): Promise<Professor[]> => {
    const token = await getSessionToken();
        
    const headers = {
        Authorization: `Bearer ${token}`, 
       'Content-Type': 'application/json'
    }
    console.log('headers', headers);

    const response = await fetch(`${API_URL}/professors`, {
        method: 'GET',
        headers: headers
    });

    if (!response.ok) {
        throw new Error('Failed to fetch professors');
    }

    return await response.json();
};


export const professorsService = {
    records: [] as Professor[], // Holds the list of professor objects

    // Initialize with fetched data
    async initialize() {
        this.records = await fetchProfessors(); // Fetch professors from API
    },

    // Get all professors with optional search
    async getAll(options: {
        search?: string;
        category?: string; // Add the category filter
    } = {}) {
        let professors = [...this.records];

        // Search functionality across multiple fields
        if (options.search) {
            professors = professors.filter(professor =>
                professor.firstName.toLowerCase().includes(options.search!.toLowerCase()) ||
                professor.lastName.toLowerCase().includes(options.search!.toLowerCase())
            );
        }

         // Apply category filter
         if (options.category) {
            professors = professors.filter(professor =>
                professor.category.name.toLowerCase() === options.category!.toLowerCase()
                )
        }


        return professors;
    },

    // Get paginated results with optional search
    async getProfessors({
        page = 1,
        limit = 10,
        ...filterOptions
    }: {
        page?: number;
        limit?: number;
        search?: string;
        category?: string;
    }) {
        const allProfessors = await this.getAll(filterOptions);
        const totalProfessors = allProfessors.length;

        // Pagination logic
        const offset = (page - 1) * limit;
        const paginatedProfessors = allProfessors.slice(offset, offset + limit);

        // Return paginated response
        return {
            success: true,
            total_professors: totalProfessors,
            offset,
            limit,
            professors: paginatedProfessors
        };
    }
};

professorsService.initialize();