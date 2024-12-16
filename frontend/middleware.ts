// Protecting routes with next-auth
// https://next-auth.js.org/configuration/nextjs#middleware
// https://nextjs.org/docs/app/building-your-application/routing/middleware


import NextAuth from 'next-auth';
import authConfig from './auth.config';

const { auth } = NextAuth(authConfig);

export default auth(async (req) => {
  // Check if the user is authenticated and get the role
  const userRole = req.auth?.user.role; 

  // Handle redirection
  if (req.auth && req.nextUrl.pathname === '/admin') {
    const dashboardUrl = req.nextUrl.clone();
    if (userRole === 'ROLE_ADMIN'){
      dashboardUrl.pathname ='/admin/dashboard';
      return Response.redirect(dashboardUrl);
    }
  }
  if (req.auth && req.nextUrl.pathname === '/prof') {
    const dashboardUrl = req.nextUrl.clone();
    if (userRole === 'ROLE_PROF'){
      dashboardUrl.pathname = '/prof/dashboard';
      return Response.redirect(dashboardUrl);
    }
  }

  // Route protection based on the user role
  if (req.nextUrl.pathname.startsWith('/admin')) {
    if (userRole === 'ROLE_ADMIN') {
      return; // Allow access to admin users
    } else {
      // Redirect non-admin users attempting to access admin routes
      const notAuthorizedUrl = req.nextUrl.clone();
      notAuthorizedUrl.pathname = '/'; // Redirect to login or "Not Authorized" page
      return Response.redirect(notAuthorizedUrl);
    }
  }

  if (req.nextUrl.pathname.startsWith('/prof')) {
    if (userRole === 'ROLE_PROF') {
      return; // Allow access to prof users
    } else {
      // Redirect non-prof users attempting to access prof routes
      const notAuthorizedUrl = req.nextUrl.clone();
      notAuthorizedUrl.pathname = '/'; // Redirect to login or "Not Authorized" page
      return Response.redirect(notAuthorizedUrl);
    }
  }

  // Redirect authenticated users to their respective dashboards based on role
  if (req.auth && req.nextUrl.pathname === '/') {
    const dashboardUrl = req.nextUrl.clone();
    dashboardUrl.pathname = userRole === 'ROLE_ADMIN' ? '/admin/dashboard' : '/prof/dashboard';
    return Response.redirect(dashboardUrl);
  }

  // Redirect unauthenticated users to the login page if trying to access protected routes
  if (!req.auth && req.nextUrl.pathname !== '/') {
    const loginUrl = req.nextUrl.clone();
    loginUrl.pathname = '/';
    return Response.redirect(loginUrl);
  }
});

export const config = { matcher: ['/', '/admin/:path*', '/prof/:path*'] };



// import NextAuth from 'next-auth';
// import authConfig from './auth.config';

// const { auth } = NextAuth(authConfig);

// export default auth(async (req) => {
//   // eslint-disable-next-line no-console
//   console.log('req.auth', req.auth);

//   // Check if the user is authenticated
//   if (req.auth) {
//     // If authenticated and trying to access the login page, redirect to the dashboard
//     if (req.nextUrl.pathname === '/') {
//       // Construct an absolute URL for the dashboard
//       const dashboardUrl = req.nextUrl.clone();
//       dashboardUrl.pathname = '/dashboard'; // Set the new pathname
//       return Response.redirect(dashboardUrl); // Use the absolute URL
//     }
//   } else {
//     // If not authenticated, redirect to the login page for other routes
//     if (req.nextUrl.pathname !== '/') {
//       // Construct an absolute URL for the login page
//       const loginUrl = req.nextUrl.clone();
//       loginUrl.pathname = '/'; // Set the new pathname for the login page
//       return Response.redirect(loginUrl); // Use the absolute URL
//     }
//   }
// });

// export const config = { matcher: ['/dashboard/:path*', '/'] }; // Include the login page in the matcher
