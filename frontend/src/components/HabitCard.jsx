import HabitVisualization from "./HabitVisualization"

function HabitCard({name = "Unnamed", lastEntries}) {
    return (
        <fieldset>
            <legend>{name}</legend>
            <HabitVisualization
                lastEntries={lastEntries}
                targetRowCount={1}
                showEmptyRows={true}
                habiName={name}
            />
            <div className="toolbar-container">
                <button>Details</button>
                <button>Log entry</button>
            </div>
        </fieldset>
    )
}

export default HabitCard