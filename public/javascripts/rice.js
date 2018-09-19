function checkMe(name) {
    if (confirm("Are you sure you want to delete profile? It can't be undone!")) {
        return true;
    } else {
        return false;
    }
}
