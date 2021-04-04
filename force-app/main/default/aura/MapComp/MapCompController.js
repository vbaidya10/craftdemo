({
    init: function (cmp, event, helper) {
        cmp.set('v.mapMarkers', [
            {
                location: {
                    City: cmp.get("v.source"),
                    Country: 'India'
                },
                value: 'India1',
                title: 'Source'
            },
            {
                location: {
                    City: cmp.get("v.currentLocation"),
                    Country: 'India'
                },
                value: 'India2',
                title: 'Current Location'
            },
            {
                location: {
                    City: cmp.get("v.destination"),
                    Country: 'India'
                },
                value: 'India3',
                title: 'Destination'
            }
        ]);
        cmp.set('v.markersTitle', 'India');
    },
    
    handleMarkerSelect: function (cmp, event, helper) {
        var marker = event.getParam("selectedMarkerValue");
    }
})