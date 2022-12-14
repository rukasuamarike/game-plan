from flask import Flask, send_from_directory, render_template
import requests, math, random

app = Flask(__name__, template_folder='take_break')

@app.route('/dashboard/<latitude>/<longtitude>/<dateTime>')
def get_trip(latitude, longtitude, dateTime):

    # latitude = 37.795270
    # longtitude = -122.411110
    # dateTime = "2022-11-16 00:00:00.000"

    payload, headers= {}, {}
    dateTimeFormatted = f"{dateTime[:10]}T{dateTime[11:19].replace(':','%3A')}Z"
    LAT_LNG_MULTIPLIER = 111139
    MAPS_API_TOKEN = "AIzaSyD5DqXn4kkLZAks-koDJEnR8FeMi1fnMvo"

    # Retrieve Inrix Authentication Token
    INRIX_AUTH_URL = "https://api.iq.inrix.com/auth/v1/appToken?appId=fkueo2tfv7&hashToken=Zmt1ZW8ydGZ2N3xMV21QS1NLV2dQODcyRTJwN1lyYnNhTjN6RnM4RHJZMDE3QjhRamcx"
    response = requests.request("GET", INRIX_AUTH_URL, headers=headers, data=payload).json()
    INRIX_TOKEN = response["result"]["token"]

    # Calculate radius based on location/time
    INRIX_URL = f"https://api.iq.inrix.com/drivetimePolygons?center={latitude}%7C{longtitude}&rangeType=D&duration=5&dateTime={dateTimeFormatted}&token={INRIX_TOKEN}"
    response = requests.request("GET", INRIX_URL, headers=headers, data=payload)
    coords = response.text[response.text.index("<posList>")+len("<posList>"):response.text.index("</posList>")].split()
    radius = LAT_LNG_MULTIPLIER * math.sqrt((float(coords[0])-float(latitude))**2 + (float(coords[1])-float(longtitude))**2)

    # Lists for categories/locations
    fun_categories = ["amusement_park", "aquarium", "art_gallery", "bowling_alley", "book_store", "casino", "night_club", "museum", "park", "spa", "tourist_attraction", "zoo"]
    food_categories = ["cafe", "restaurant", "bar"]
    fun_locations, food_locations = [], []             

    # For loop through categories 
    for category in fun_categories+food_categories:
        PLACES_URL = f"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location={latitude}%2C{longtitude}&radius={radius}&type={category}&key={MAPS_API_TOKEN}"
        response = requests.request("GET", PLACES_URL, headers=headers, data=payload).json().get("results")

        for place in response:

            # place_id = place["place_id"]                                  
            # PLACE_URL = f"https://maps.googleapis.com/maps/api/place/details/json?place_id={place_id}&fields=name%2Cformatted_address%2Cprice_level%2Copening_hours%2Cgeometry%2Ctypes&key={MAPS_API_TOKEN}"
            # response = requests.request("GET", PLACE_URL, headers=headers, data=payload).json().get("result")

            # Break out of loop if business is not operational or closed on given day
            # response.get("opening_hours") is None or response.get("opening_hours").get("periods").get("weekday_text")[DAY_OF_WEEK][-6:] == "Closed"

            # Add important values to new dictionary
            location = {} 
            location["types"] = place.get("types")
            location["name"] = place.get("name")
            location["price"] = place.get("price_level")

            # Calculate rating based on average rating and number of ratings
            average_rating, rating_count = place.get("rating"), place.get("user_ratings_total")
            if type(average_rating) == type(0.1) and type(rating_count) == type(1):
                location["rating"] = (3*2+rating_count*average_rating)/(3+rating_count)
                if location["rating"] < 3:
                    break
            
            # location["open_time"] = response["opening_hours"]["periods"][1].get("open").get("time")
            # location["close_time"] = response["opening_hours"]["periods"][1].get("close").get("time")

            # Find route and add travel time to location object
            location["latitude"] = place["geometry"]["location"]["lat"]
            location["longtitude"] = place["geometry"]["location"]["lng"]                       

            # Append location to list of locations
            for loc_type in location["types"]:
                if loc_type in food_categories:
                    food_locations.append(location)
                elif loc_type in fun_categories:
                    fun_locations.append(location)

    trips = {}
    trips["trips"] = []
    for _ in range(3):

        # Parse time and add locations/parking list
        time = int(dateTime[11:13]+dateTime[14:16])
        trip, coordinates = {}, [[latitude, longtitude]]
        trip["locations"], trip["parking"] = [], []

        for _ in range(3):

            # Choose food/fun depending on time
            if (time > 1300 and time < 1500) or (time > 1930 and time < 2100):
                location = random.choice(food_locations)
                food_locations.remove(location)
            else:
                location = random.choice(fun_locations)
                fun_locations.remove(location)
            
            # Append coordinates and location to response
            location_latitude, location_longtitude = location["latitude"], location["longtitude"]
            coordinates.append([location_latitude, location_longtitude])
            trip["locations"].append(location)
            
            time += 200
        
        # Add coordinates to route query
        findRouteQuery = ''
        coordinates.append([latitude, longtitude])
        for i in range(1,6):
            findRouteQuery += f"wp_{i}={coordinates[i-1][0]}%2C{coordinates[i-1][1]}0&"
        
        # Add travel time to trips
        ROUTE_URL = f"https://api.iq.inrix.com/findRoute?{findRouteQuery}format=json&token={INRIX_TOKEN}"
        response = requests.request("GET", ROUTE_URL, headers=headers, data=payload).json().get("result").get("trip")
        travel_time = response["routes"][0]["travelTimeMinutes"]
        trip["travel_time"] = travel_time
        trips["trips"].append(trip)

    return trips

if __name__ == '__main__':
    app.run()

# Add parking to response object
# PARKING_URL = f"https://api.iq.inrix.com/lots/v3?point={location_latitude}%7C{location_longtitude}&radius=500"
# response = requests.request("GET", PARKING_URL, headers=headers, data=payload).json().get("result")
# parking_lot = {}
# address_endpoint = response.get("navigationAddress")
# parking_address = [address_endpoint.get("street"), address_endpoint.get("city"), address_endpoint.get("state"), address_endpoint.get("postal")]
# parking_lot["name"] = response.get("name")
# parking_lot["address"] = f"{parking_address[0]}, {parking_address[1]}, {parking_address[2]}, {parking_address[3]}"
# trip["parking"].append(parking_lot)