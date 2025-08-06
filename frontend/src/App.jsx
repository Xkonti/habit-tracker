import {
  QueryClient,
  QueryClientProvider,
} from '@tanstack/react-query'

import MainPage from './pages/MainPage.jsx'
// import './App.css'

const queryClient = new QueryClient()

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <div>
        <MainPage />
      </div>
    </QueryClientProvider>
  )
}

export default App
