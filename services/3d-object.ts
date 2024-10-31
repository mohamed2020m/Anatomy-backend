import { ThreeDObject } from "../constants/data"
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

// Fetch all categories
export const fetchCategories = async (): Promise<ThreeDObject[]> => {
    const token = await getSessionToken();
    console.log('jwt token', token);
    
    const headers = {
        Authorization: `Bearer ${token}`, 
       'Content-Type': 'application/json'
    }
    console.log('headers', headers);

    const response = await fetch(`${API_URL}/threeDObjects`, {
        method: 'GET',
        headers: headers
    });

    if (!response.ok) {
        throw new Error('Failed to fetch categories');
    }

    return await response.json();
};




export const categoriesService = {
    records: [] as ThreeDObject[], // Holds the list of category objects

    // Initialize with fetched data
    async initialize() {
        this.records = await fetchCategories(); // Fetch categories from API
    },

    // Get all categories with optional search
    async getAll({ search }: { search?: string }) {
        let categories = [...this.records];

        // Search functionality across multiple fields
        if (search) {
            categories = categories.filter(category =>
                category.name.toLowerCase().includes(search.toLowerCase()) ||
                category.description.toLowerCase().includes(search.toLowerCase())
            );
        }

        // Fetch and set images for each category
        const categoriesWithImages = await Promise.all(categories.map(async (category) => {
            const imageUrl = `${API_URL}/files/download/${category.image}` 
            return { ...category, image: imageUrl }; 
        }));

        return categoriesWithImages;
    },

    // Get paginated results with optional search
    async getCategories({
        page = 1,
        limit = 10,
        search
    }: {
        page?: number;
        limit?: number;
        search?: string;
    }) {
        const allCategories = await this.getAll({ search });
        const totalCategories = allCategories.length;

        // Pagination logic
        const offset = (page - 1) * limit;
        const paginatedCategories = allCategories.slice(offset, offset + limit);

        // Return paginated response
        return {
            success: true,
            total_categories: totalCategories,
            offset,
            limit,
            categories: paginatedCategories
        };
    }
};

categoriesService.initialize();