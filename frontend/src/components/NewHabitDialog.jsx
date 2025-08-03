import { useEffect, useRef, useState } from "react"

function NewHabitDialog({
    isOpen,
    onClose,
    onNewEntry,
}) {
    const dialog = useRef(null)
    const [habitName, setHabitName] = useState('')
    const [isError, setIsError] = useState(false)

    useEffect(() => {
        console.log("isOpen changed:", isOpen)
        if (isOpen) {
            setHabitName('')
            setIsError(false)
            dialog.current?.showModal()
        }
        else dialog.current?.close()
    }, [isOpen])

    function handleNewHabitClick() {
        const success = onNewEntry({name: habitName})
        if (!success) {
            setIsError(true)
        }
    }

    return (
        <dialog ref={dialog} className="window">
            <div className="title-bar">
                <div className="title-bar-text">Add new habit</div>
                <div className="title-bar-controls">
                <button aria-label="Close" onClick={onClose}></button>
                </div>
            </div>
            <div className="window-body">
                <div class="field-row" style={{marginBottom: "4px"}}>
                    <label for="newHabitName">Name:</label>
                    <input id="newHabitName" type="text" value={habitName} onChange={(e) => setHabitName(e.target.value)} />
                </div>
                { isError && (
                    <div style={{marginBottom: "4px"}}>
                        Habit with this name already exists
                    </div>
                )}
                <div className="toolbar-container">
                    <button disabled={habitName.length < 3} onClick={handleNewHabitClick}>Add</button>
                </div>
            </div>
        </dialog>
    )
}

export default NewHabitDialog