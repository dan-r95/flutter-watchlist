from justwatch import JustWatch
import json

just_watch = JustWatch(country="DE")
query = just_watch.search_title_id("the matrix")
print(query)
titles = just_watch.get_title(next(iter(query.values()))) #get first key
#print(titles['offers'])
#print(json.dumps(titles['offers']))
for data in titles['offers']:
    #print(data["provider_id"], data["monetization_type"])
    if(data["monetization_type"] == "flatrate"):
        print("available on: ", data["urls"], "id: ", data["provider_id"])
#if titles['offers'].

provs =just_watch.get_providers()
#print(provs)