var sharedData: SharedObject = SharedObject.getLocal("drca_shared_data", "/");

function saveSharedData(key: String, value: Object) {
	sharedData.data.key = value;
	sharedData.flush();
}

function getSharedData(key): Object {
	return sharedData.data.key;
}

function clearSharedData(key): Object {
	saveSharedData(key, undefined);
}