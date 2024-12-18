/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    domains: ['utfs.io', 'api.slingacademy.com',  'thecatapi.com', 'cdn2.thecatapi.com', 'localhost'],
     remotePatterns: [
      {
        protocol: 'http',
        hostname: process.env.BACKEND_HOST || 'localhost',
        port: process.env.BACKEND_PORT || '8080',  
        pathname: '/api/v1/files/download/**',
      },
    ],
  }
};

module.exports = nextConfig;
