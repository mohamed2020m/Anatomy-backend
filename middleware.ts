// Protecting routes with next-auth
// https://next-auth.js.org/configuration/nextjs#middleware
// https://nextjs.org/docs/app/building-your-application/routing/middleware

import NextAuth from 'next-auth';
import authConfig from './auth.config';

const { auth } = NextAuth(authConfig);

export default auth(async (req) => {
  // eslint-disable-next-line no-console
  console.log('req.auth', req.auth);

  // Check if the user is authenticated
  if (req.auth) {
    // If authenticated and trying to access the login page, redirect to the dashboard
    if (req.nextUrl.pathname === '/') {
      // Construct an absolute URL for the dashboard
      const dashboardUrl = req.nextUrl.clone();
      dashboardUrl.pathname = '/dashboard'; // Set the new pathname
      return Response.redirect(dashboardUrl); // Use the absolute URL
    }
  } else {
    // If not authenticated, redirect to the login page for other routes
    if (req.nextUrl.pathname !== '/') {
      // Construct an absolute URL for the login page
      const loginUrl = req.nextUrl.clone();
      loginUrl.pathname = '/'; // Set the new pathname for the login page
      return Response.redirect(loginUrl); // Use the absolute URL
    }
  }
});

export const config = { matcher: ['/dashboard/:path*', '/'] }; // Include the login page in the matcher
