import { useEffect, useRef, useState } from "react"
import DateSelector from "./DateSelector"

function LogHabitEntryDialog({
    isOpen,
    onClose,
    habitName,
    logMutation,
}) {
    const dialog = useRef(null)
    const [date, setDate] = useState(new Date())
    const [logValue, setLogValue] = useState(false)
    const [notes, setNotes] = useState('')

    const {mutate: saveLog, isPending, isError } = logMutation

    useEffect(() => {
        if (isOpen) {
            // When opening dialog box, reset inputs
            setDate(new Date())
            setLogValue(false)
            setNotes('')
            dialog.current?.showModal()
        }
        else dialog.current?.close()
    }, [isOpen])

    const isSavingIntiated = useRef(false)

    useEffect(() => {
        if (!isSavingIntiated.current) return;
        if (!isPending && isError) {
            isSavingIntiated.current = false;
        } else if (!isPending && !isError) {
            onClose()
            isSavingIntiated.current = false;
        }
    }, [isPending, isError, onClose])

    async function handleLogClick() {
        isSavingIntiated.current = true
        const dateString = `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`
        saveLog({ habitName, date: dateString, value: logValue, notes});
    }

    return (
        <dialog ref={dialog} className="window">
            <div className="title-bar">
                <div className="title-bar-text">Log activity</div>
                <div className="title-bar-controls">
                { !isPending && <button aria-label="Close" onClick={onClose}></button> }
                </div>
            </div>
            <div className="window-body">
                { !isPending && (
                    <>
                        <div style={{marginBottom: "4px"}}>{habitName}</div>
                        
                        { isError && <div style={{marginBottom: "4px"}}>Failed to save!</div> }

                        <DateSelector date={date} onDateChange={setDate} />

                        <div style={{marginBottom: "4px"}}>
                            <input type="checkbox" id="logValue" checked={logValue} onChange={(e) => setLogValue(e.target.checked)} />
                            <label htmlFor="logValue">Habit fulfilled</label>
                        </div>

                        <div className="field-row-stacked" style={{marginBottom: "4px"}}>
                            <label htmlFor="newNotes">Notes:</label>
                            <textarea
                                id="newNotes"
                                rows="6"
                                value={notes}
                                onChange={(e) => setNotes(e.target.value)}
                            />
                        </div>
                        <div className="toolbar-container">
                            <button onClick={handleLogClick}>Save</button>
                        </div>
                    </>
                )}
                { isPending && <span>Adding new log entry...</span> }
            </div>
        </dialog>
    )
}

export default LogHabitEntryDialog