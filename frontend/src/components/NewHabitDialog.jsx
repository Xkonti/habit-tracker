import { useEffect, useRef, useState } from "react"

function NewHabitDialog({
    isOpen,
    onClose,
    habitMutation,
}) {
    const dialog = useRef(null)
    const [habitName, setHabitName] = useState('')
    const [isError, setIsError] = useState(false)

    const {mutate: saveHabit, isPending: isSavingPending, isError: didSaveFail } = habitMutation

    useEffect(() => {
        if (isOpen) {
            setHabitName('')
            setIsError(false)
            dialog.current?.showModal()
        }
        else dialog.current?.close()
    }, [isOpen])

    const isSavingIntiated = useRef(false)

    useEffect(() => {
        if (!isSavingIntiated.current) return;
        if (!isSavingPending && didSaveFail) {
            setIsError(true)
            isSavingIntiated.current = false;
        } else if (!isSavingPending && !didSaveFail) {
            onClose()
            isSavingIntiated.current = false;
        }
    }, [isSavingPending, didSaveFail, onClose])

    async function handleNewHabitClick() {
        isSavingIntiated.current = true
        saveHabit({ habitName: habitName});
    }

    return (
        <dialog ref={dialog} className="window">
            <div className="title-bar">
                <div className="title-bar-text">Add new habit</div>
                <div className="title-bar-controls">
                { !isSavingPending && <button aria-label="Close" onClick={onClose}></button> }
                </div>
            </div>
            <div className="window-body">
                { !isSavingPending && !didSaveFail && (
                    <>
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
                    </>
                )}
                { isSavingPending && <span>Saving new habit...</span> }
            </div>
        </dialog>
    )
}

export default NewHabitDialog