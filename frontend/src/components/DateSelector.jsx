function DateSelector({date, onDateChange}) {

    const year = date.getFullYear()
    const month = date.getMonth()
    const day = date.getDate()
    
    const listOfYears = Array.from({length: 5}, (_, i) => year - 4 + i)
    const numberOfDays = new Date(year, month + 1, 0).getDate()
    const listOfDays = Array.from({length: numberOfDays}, (_, i) => i + 1)

    function changeDate(newYear, newMonth, newDay) {
        const newNumberOfDays = new Date(newYear, newMonth + 1, 0).getDate()
        if (newDay > newNumberOfDays) {
            newDay = newNumberOfDays
        }
        const newDate = new Date(newYear, newMonth, newDay, 0, 0, 0, 0)
        console.log({newDate})
        onDateChange(newDate)
    }

    function onYearChange(newYear) { changeDate(parseInt(newYear), month, day) }
    function onMonthChange(newMonth) { changeDate(year, parseInt(newMonth), day) }
    function onDayChange(newDay) { changeDate(year, month, parseInt(newDay)) }

    return (
        <div style={{'display': 'flex', 'align-items': 'center'}}>
            <select value={year} onChange={(e) => onYearChange(e.target.value)}>
                { listOfYears.map((year) => (
                    <option>{year}</option>
                )) }
            </select>
            <select value={month} onChange={(e) => onMonthChange(e.target.value)}>
                <option value={0}>Jan</option>
                <option value={1}>Feb</option>
                <option value={2}>Mar</option>
                <option value={3}>Apr</option>
                <option value={4}>May</option>
                <option value={5}>Jun</option>
                <option value={6}>Jul</option>
                <option value={7}>Aug</option>
                <option value={8}>Sep</option>
                <option value={9}>Oct</option>
                <option value={10}>Nov</option>
                <option value={11}>Dec</option>
            </select>
            <select value={day} onChange={(e) => onDayChange(e.target.value)}>
                { listOfDays.map((day) => (
                    <option>{day}</option>
                )) }
            </select>
        </div>
    )
}

export default DateSelector