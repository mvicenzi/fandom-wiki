/// --------------------------------------------------
// Name: downloadAnalyticsData()
// Author: Daeron_del_Doriath
// Use: This function can be called in the browser console on the
// Special:Analytics page to trigger the download of a json file storing
// all the analytics data. It includes data from all graphs and tables.
/// --------------------------------------------------

function downloadAnalyticsData() {
    // Step 1: Create a plain object to hold all serializable data
    var combinedData = {};

    // Step 2: Add `window.sectionsData` to the combined data object
    combinedData.sectionsData = {};
    for (var key in window.sectionsData) {
        if (window.sectionsData.hasOwnProperty(key)) {
            combinedData.sectionsData[key] = window.sectionsData[key];
        }
    }

    // Step 3: Function to extract table data from specified divs and add it to the combined data object
    function extractTableDataFromDivs() {
        var divIds = ['geolocation', 'top_viewed_pages', 'most_visited_files','top_search_terms'];

        for (var i = 0; i < divIds.length; i++) {
            var divId = divIds[i];
            var table = document.querySelector('#' + divId + ' table.analytics_table');
            if (table) {
                combinedData[divId] = extractTableData(table);
            }
        }
    }

    // Step 4: Extract table data from a specific table element and return as an array of objects
    function extractTableData(table) {
        var rows = table.querySelectorAll('tr');

        // Extract headers
        var headers = [];
        var headerCells = rows[0].querySelectorAll('th');
        for (var h = 0; h < headerCells.length; h++) {
            headers.push(headerCells[h].innerText.trim());
        }

        // Extract data rows and convert each row to an object with headers as keys
        var data = [];
        for (var r = 1; r < rows.length; r++) {
            var row = rows[r];
            var cols = row.querySelectorAll('td');
            var rowData = {};
            for (var j = 0; j < headers.length; j++) {
                rowData[headers[j]] = cols[j] ? cols[j].innerText.trim() : '';
            }
            data.push(rowData);
        }

        return data;
    }

    // Step 5: Run the extraction process
    extractTableDataFromDivs();

    // Step 6: Download the combined data as a JSON file
    var blob = new Blob([JSON.stringify(combinedData, null, 2)], { type: 'application/json' });
    var url = URL.createObjectURL(blob);
    var downloadAnchorNode = document.createElement('a');
    downloadAnchorNode.setAttribute("href", url);
    downloadAnchorNode.setAttribute("download", "analytics_data.json");
    document.body.appendChild(downloadAnchorNode);
    downloadAnchorNode.click();
    document.body.removeChild(downloadAnchorNode);
    URL.revokeObjectURL(url);
}
