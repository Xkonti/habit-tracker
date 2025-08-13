import { useParams } from "react-router";

import {
  useQuery,
} from '@tanstack/react-query'

function MainPage() {
    const { habitName } = useParams()

    // Habit data
    const { isPending, isError, data } = useQuery({ queryKey: ['habit', habitName], queryFn: async () => {
        const response = await fetch(`http://localhost:8080/api/habit/${btoa(habitName)}`)
        if (response.ok) {
            return response.json();
        }
        throw new Error(`HTTP error when fetching habit '${habitName}': ${response.status}`)
    }})

    const logEntries = data?.logEntries ?? []

    return (
        <>
            { isPending && <h3>Loading data for "{habitName}" habit...</h3> }
            { isError && <h3>Failed to load data for "{habitName}" habit</h3> }
            { !isPending && !isError && (
                <>
                    <h3>{data.name ?? habitName}</h3>
                    <p>{data.description ?? ''}</p>
                    <p>This is where the habit visualization will go.</p>
                    <div className="sunken-panel" style={{height: "120px", width: "240px"}}>
                        <table className="interactive">
                            <thead>
                            <tr>
                                <th></th>
                                <th>Date</th>
                                <th>Notes</th>
                            </tr>
                            </thead>
                            <tbody>
                            { logEntries.map((entry) => (
                                <tr key={entry.date}>
                                    <td>
                                        <input type="checkbox" checked={entry.value} onChange={() => {}} />
                                        <label></label>
                                    </td>
                                    <td>
                                        {entry.date.split('T')[0]}
                                    </td>
                                    <td>
                                        { entry.notes && <p>{entry.notes}</p> }
                                    </td>
                                </tr>
                            ))}
                            </tbody>
                        </table>
                    </div>
                </>
            )}
        </>
    )
}

export default MainPage