const entriesPerRow = 10

function HabitVisualization({
    lastEntries = [],
    targetRowCount = 1,
    showEmptyRows = true,
    habitName = '',
}) {
    // Eariest entry calculate based on current date and number of entries to display
    // 1. Get the today's date without time
    // 2. Subtract entriesPerRow (10) * targetRowCount;
    // 3. Construct the date
    // 4. Find a way to use it as an index
    // const maxEntries = entriesPerRow * targetRowCount
    // const earliestDate = 
    // const fullHistory = []


    const rowCount = showEmptyRows
        ? targetRowCount
        : Math.min(Math.ceil(lastEntries.length / entriesPerRow), targetRowCount)
    
    const rows = []
    for (let rowIndex = 0; rowIndex < rowCount; rowIndex += 1) {
        const entries = []
        for (let entryIndex = entriesPerRow; entryIndex > 0; entryIndex -= 1) {
            const currentEntryIndex = lastEntries.length - entryIndex - (rowIndex * entriesPerRow);
            const uniqueKey = `${habitName}-${rowIndex}-${currentEntryIndex}`
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
        const rowKey = `${habitName}-${rowIndex}`
        rows.push(<div key={rowKey}>{entries}</div>)
    }

    return (
        <div style={{"marginBottom": "12px"}}>
            {rows}
        </div>
    )
}

export default HabitVisualization