function MainToolbar({onAddHabit}) {
    return (
        <div className="toolbar-container">
            <button onClick={onAddHabit}>Add habit</button>
        </div>
    )
}

export default MainToolbar