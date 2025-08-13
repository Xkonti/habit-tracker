// import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import {
  createBrowserRouter,
  RouterProvider,
} from "react-router";
import {
  QueryClient,
  QueryClientProvider,
} from '@tanstack/react-query'

// import './index.css'
import MainPage from './pages/MainPage.jsx'
import HabitDetails from './pages/HabitDetails.jsx'

const router = createBrowserRouter([
  {
    path: "/",
    Component: MainPage,
  },
  {
    path: "habits",
    children: [
      { path: ":habitName", Component: HabitDetails },
    ],
  }
]);

const queryClient = new QueryClient()

createRoot(document.getElementById('root')).render(
  <QueryClientProvider client={queryClient}>
      <RouterProvider router={router} />
    </QueryClientProvider>
)
