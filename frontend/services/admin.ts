import { Admin } from "../constants/data"
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
export const fetchAdmins = async (): Promise<Admin[]> => {
    const token = await getSessionToken();
    console.log('jwt token', token);
    
    const headers = {
        Authorization: `Bearer ${token}`, 
       'Content-Type': 'application/json'
    }
    console.log('headers', headers);

    const response = await fetch(`${API_URL}/administrators`, {
        method: 'GET',
        headers: headers
    });

    if (!response.ok) {
        throw new Error('Failed to fetch admins');
    }

    return await response.json();
};


export const fetchAdminsByID = async (): Promise<Admin[]> => {
    const token = await getSessionToken();
        
    const headers = {
        Authorization: `Bearer ${token}`, 
       'Content-Type': 'application/json'
    }
    console.log('headers', headers);

    const response = await fetch(`${API_URL}/administrators`, {
        method: 'GET',
        headers: headers
    });

    if (!response.ok) {
        throw new Error('Failed to fetch admins');
    }

    return await response.json();
};


export const adminsService = {
    records: [] as Admin[], // Holds the list of admin objects

    // Initialize with fetched data
    async initialize() {
        this.records = await fetchAdmins(); // Fetch admins from API
    },

    // Get all admins with optional search
    async getAll({ search }: { search?: string }) {
        let admins = [...this.records];

        // Search functionality across multiple fields
        if (search) {
            admins = admins.filter(admin =>
                admin.firstName.toLowerCase().includes(search.toLowerCase()) ||
                admin.lastName.toLowerCase().includes(search.toLowerCase())
            );
        }


        return admins;
    },

    // Get paginated results with optional search
    async getAdmins({
        page = 1,
        limit = 10,
        search
    }: {
        page?: number;
        limit?: number;
        search?: string;
    }) {
        const allAdmins = await this.getAll({ search });
        const totalAdmins = allAdmins.length;

        // Pagination logic
        const offset = (page - 1) * limit;
        const paginatedAdmins = allAdmins.slice(offset, offset + limit);

        // Return paginated response
        return {
            success: true,
            total_admins: totalAdmins,
            offset,
            limit,
            admins: paginatedAdmins
        };
    }
};

adminsService.initialize();