const entriesPerRow = 10

function HabitVisualization({
    lastEntries = [],
    targetRowCount = 1,
    showEmptyRows = true,
    habitName = '',
}) {
    const rowCount = showEmptyRows
        ? targetRowCount
        : Math.min(Math.ceil(lastEntries.length / entriesPerRow), targetRowCount)
    
    const rows = []
    for (let rowIndex = 0; rowIndex < rowCount; rowIndex += 1) {
        const entries = []
        for (let entryIndex = entriesPerRow; entryIndex > 0; entryIndex -= 1) {
            const currentEntryIndex = lastEntries.length - entryIndex - (rowIndex * entriesPerRow);
            const uniqueKey = `${habitName}-${currentEntryIndex}`
            if (currentEntryIndex >= 0) {
                const currentEntryValue = lastEntries[currentEntryIndex]
                entries.push(
                    <span key={uniqueKey}>
                        <input
                            checked={currentEntryValue}
                            type="checkbox"
                        />
                        <label></label>
                    </span>
                )
            } else {
                entries.push(
                    <span key={uniqueKey}>
                        <input
                            disabled
                            type="checkbox"
                        />
                        <label></label>
                    </span>
                )
            }
        }
        rows.push(<div>{entries}</div>)
    }

    return (
        <div style={{"marginBottom": "12px"}}>
            {rows}
        </div>
    )
}

export default HabitVisualization