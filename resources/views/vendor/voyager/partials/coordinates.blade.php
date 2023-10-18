<style>
    #map {
        height: 400px;
        width: 100%;
    }
</style>

<script type="application/javascript">
    function initMap() {
        @if($dataTypeContent->location instanceof \Grimzy\LaravelMysqlSpatial\Types\Point)
            var center = {
                lat: {{ $dataTypeContent->location->getLat() }},
                lng: {{ $dataTypeContent->location->getLng() }}
            };
        @else
            var center = {
                lat: {{ config('voyager.googlemaps.center.lat') }},
                lng: {{ config('voyager.googlemaps.center.lng') }}
            };
        @endif

        var map = new google.maps.Map(document.getElementById('map'), {
            zoom: {{ config('voyager.googlemaps.zoom') }},
            center: center
        });
        var markers = [];

        @if($dataTypeContent->location->getLat() != null)
            var marker = new google.maps.Marker({
                position: {
                    lat: {{ $dataTypeContent->location->getLat() }},
                    lng: {{ $dataTypeContent->location->getLng() }}},
                map: map
            });
        @endif

        markers.push(marker);
    }
</script>
<div id="map"/>
<script async defer
        src="https://maps.googleapis.com/maps/api/js?key={{ config('voyager.googlemaps.key') }}&callback=initMap"></script>