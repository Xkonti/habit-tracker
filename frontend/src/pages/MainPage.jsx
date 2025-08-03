import { useState } from 'react'
import HabitCard from '../components/HabitCard.jsx'
import MainToolbar from '../components/MainToolbar.jsx'
import './MainPage.css'
import NewHabitDialog from '../components/NewHabitDialog.jsx'

const dataFromServer = {
    habits: [
        {
            name: "Stream every day",
            history: [
                {
                    date: "2025.07.01",
                    value: true
                },
                {
                    date: "2025.07.02",
                    value: false
                },
                {
                    date: "2025.07.03",
                    value: true
                },
                {
                    date: "2025.07.04",
                    value: true
                },
            ],
        },
        {
            name: "Work on side project for 30m",
            history: [
                {
                    date: "2025.07.01",
                    value: true
                },
                {
                    date: "2025.07.02",
                    value: false
                },
                {
                    date: "2025.07.03",
                    value: true
                },
                {
                    date: "2025.07.04",
                    value: true
                },
            ],
        },
        {
            name: "Read technical book for 30m",
            history: [
                {
                    date: "2025.07.01",
                    value: true
                },
                {
                    date: "2025.07.04",
                    value: true
                },
                {
                    date: "2025.07.02",
                    value: false
                },
                {
                    date: "2025.07.03",
                    value: true
                },
                {
                    date: "2025.07.05",
                    value: false
                },
                {
                    date: "2021.07.01",
                    value: false
                },
            ],
        },
        {
            name: "Wake up before 10AM",
            history: [
                {
                    date: "2025.07.01",
                    value: true
                },
                {
                    date: "2025.07.02",
                    value: false
                },
                {
                    date: "2025.07.03",
                    value: true
                },
                {
                    date: "2025.07.04",
                    value: true
                },
            ],
        },
    ]
}

function MainPage() {
    const [isNewHabitDialogShown, setIsNewHabitDialogShown] = useState(false)

    const habits = dataFromServer.habits.map(habit => ({
        name: habit.name,
        entries: habit.history
            .sort((a, b) => new Date(a.date) - new Date(b.date))
            .map(e => e.value)
    }))

    const renderedHabits = habits.map(habit => 
        <HabitCard name={habit.name} lastEntries={habit.entries} key={habit.name} />
    )

    function handleNewHabit(habitData) {
        // TODO: Check if habit with same name already exists
        // this is an opportunity to return data back to dialog
        // that something failed
        
        if (dataFromServer.habits.findIndex((habit) => habit.name == habitData.name) != -1) {
            return false;
        }
        
        dataFromServer.habits.push({
            name: habitData.name,
            history: []
        })
        setIsNewHabitDialogShown(false)
        return true;
    }

    return (
        <>
            <MainToolbar onAddHabit={() => setIsNewHabitDialogShown(true)} />
            <div className="habit-cards-container" style={{"marginTop": "12px"}}>
                {renderedHabits}
            </div>
            <NewHabitDialog
                isOpen={isNewHabitDialogShown}
                onClose={() => setIsNewHabitDialogShown(false)}
                onNewEntry={handleNewHabit}
            />
        </>
    )
}

export default MainPage