import { useState } from 'react'
import HabitCard from '../components/HabitCard.jsx'
import MainToolbar from '../components/MainToolbar.jsx'
import './MainPage.css'
import NewHabitDialog from '../components/NewHabitDialog.jsx'

import {
  useQuery,
  useMutation,
  useQueryClient,
} from '@tanstack/react-query'

// const dataFromServer = {
//     habits: [
//         {
//             name: "Stream every day",
//             history: [
//                 {
//                     date: "2025.07.01",
//                     value: true
//                 },
//                 {
//                     date: "2025.07.02",
//                     value: false
//                 },
//                 {
//                     date: "2025.07.03",
//                     value: true
//                 },
//                 {
//                     date: "2025.07.04",
//                     value: true
//                 },
//             ],
//         },
//         {
//             name: "Work on side project for 30m",
//             history: [
//                 {
//                     date: "2025.07.01",
//                     value: true
//                 },
//                 {
//                     date: "2025.07.02",
//                     value: false
//                 },
//                 {
//                     date: "2025.07.03",
//                     value: true
//                 },
//                 {
//                     date: "2025.07.04",
//                     value: true
//                 },
//             ],
//         },
//         {
//             name: "Read technical book for 30m",
//             history: [
//                 {
//                     date: "2025.07.01",
//                     value: true
//                 },
//                 {
//                     date: "2025.07.04",
//                     value: true
//                 },
//                 {
//                     date: "2025.07.02",
//                     value: false
//                 },
//                 {
//                     date: "2025.07.03",
//                     value: true
//                 },
//                 {
//                     date: "2025.07.05",
//                     value: false
//                 },
//                 {
//                     date: "2021.07.01",
//                     value: false
//                 },
//             ],
//         },
//         {
//             name: "Wake up before 10AM",
//             history: [
//                 {
//                     date: "2025.07.01",
//                     value: true
//                 },
//                 {
//                     date: "2025.07.02",
//                     value: false
//                 },
//                 {
//                     date: "2025.07.03",
//                     value: true
//                 },
//                 {
//                     date: "2025.07.04",
//                     value: true
//                 },
//             ],
//         },
//     ]
// }

function MainPage() {
    const queryClient = useQueryClient()

    // Habit data
    const { isPending, isError, data } = useQuery({ queryKey: ['habits'], queryFn: async () => {
        const response = await fetch('http://localhost:8080/api/habit')
        if (response.ok) {
            return response.json();
        }
        throw new Error(`HTTP error when fetching habits: ${response.status}`)
    }})


    // Dialog and habit adding
    const [isNewHabitDialogShown, setIsNewHabitDialogShown] = useState(false)

    const habitMutation = useMutation({
        mutationFn: async ({ habitName }) => {
            const response = await fetch('http://localhost:8080/api/habit', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    name: habitName,
                })
            });
            if (response.ok) {
                return
            } else {
                throw new Error(`Error saving habits: ${response.status}`)
            }
        },
            onSuccess: () => {
                queryClient.invalidateQueries({ queryKey: ['habits'] })
        },
    })

    const habits = data?.map(habit => ({
        name: habit.name,
        entries: habit.history
            ?.sort((a, b) => new Date(a.date) - new Date(b.date))
            .map(e => e.value)
            ?? []
    })) ?? []

    const renderedHabits = habits.map(habit => 
        <HabitCard name={habit.name} lastEntries={habit.entries} key={habit.name} />
    )

    return (
        <>
            { isPending && <h1>Loading habits...</h1> }
            { isError && (
                <>
                    <h1>Failed to load habits!</h1>
                </>
            )}
            { !isPending && !isError && (
                <>
                    <MainToolbar onAddHabit={() => setIsNewHabitDialogShown(true)} />
                    <div className="habit-cards-container" style={{"marginTop": "12px"}}>
                        {renderedHabits}
                    </div>
                    <NewHabitDialog
                        isOpen={isNewHabitDialogShown}
                        onClose={() => setIsNewHabitDialogShown(false)}
                        habitMutation={habitMutation}
                    />
                </>
            )}
        </>
    )
}

export default MainPage