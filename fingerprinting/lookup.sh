APIKEY=FFJPZ0MCRAGRNZTCN

ls *.wav > wav_file_list

codegen -s 10 30 < wav_file_list > all-codes.json

curl -F "api_key=$APIKEY" -F "query=@all-codes.json" "http://developer.echonest.com/api/v4/song/identify" > all-lookups.json
