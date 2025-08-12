const entriesPerRow = 10

function HabitVisualization({
    lastEntries = [],
    targetRowCount = 1,
    showEmptyRows = true,
    habitName = '',
}) {
    const now = new Date(Date.now());
    const maxEntries = entriesPerRow * targetRowCount
    const earliestDate = new Date(now.getFullYear(), now.getMonth(), now.getDate() - maxEntries)
 
    function daysDifference(date1, date2) {
        const msPerDay = 24 * 60 * 60 * 1000
        const utc1 = Date.UTC(date1.getFullYear(), date1.getMonth(), date1.getDate())
        const utc2 = Date.UTC(date2.getFullYear(), date2.getMonth(), date2.getDate())
        return Math.floor((utc2 - utc1) / msPerDay)
    }
    
    const historyEntries = Array(maxEntries).fill(null)
    let earliestHistoryIndex = maxEntries;
    for (let entry of lastEntries) {
        const historyIndex = daysDifference(earliestDate, new Date(entry.date))
        if (historyIndex < 0) continue // This is earlier than what we can display
        if (historyIndex > maxEntries) continue // This is in the future
        historyEntries[historyIndex] = entry.value
        // Update the earliestHistoryIndex
        if (historyIndex < earliestHistoryIndex) earliestHistoryIndex = historyIndex
    }

    const rowCount = showEmptyRows
        ? targetRowCount
        : Math.min(Math.ceil((maxEntries - earliestHistoryIndex) / entriesPerRow), targetRowCount)

    const rows = []
    for (let rIndex = rowCount - 1; rIndex > -1; rIndex -= 1) {
        // In case we are hiding emptry rows, we need to calculate real row index to be able
        // to extract correct rows from historyEntries which doesn't shrink when hiding rows
        const rowIndex = rIndex + (targetRowCount - rowCount)
        const entries = []
        for (let entryIndex = 0; entryIndex < entriesPerRow; entryIndex += 1) {
            const currentEntryIndex = (rowIndex * entriesPerRow) + entryIndex;
            const uniqueKey = `${habitName}-${currentEntryIndex}`
            const entry = historyEntries[currentEntryIndex]
            entries.push(
                <span key={uniqueKey}>
                    <input
                        disabled={entry == null}
                        checked={entry ?? false}
                        type="checkbox"
                        onChange={() => {}}
                    />
                    <label></label>
                </span>
            )
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