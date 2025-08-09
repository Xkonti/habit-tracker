import HabitVisualization from "./HabitVisualization"

function HabitCard({name = "Unnamed", lastEntries, onAddLog}) {
    return (
        <fieldset>
            <legend>{name}</legend>
            <HabitVisualization
                lastEntries={lastEntries}
                targetRowCount={1}
                showEmptyRows={true}
                habitName={name}
            />
            <div className="toolbar-container">
                <button>Details</button>
                <button onClick={() => onAddLog(name)}>Log entry</button>
            </div>
        </fieldset>
    )
}

export default HabitCard