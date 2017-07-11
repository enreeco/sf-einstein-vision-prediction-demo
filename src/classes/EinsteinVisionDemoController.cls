public without sharing class EinsteinVisionDemoController {
	public String imageUrl{get;set;}
	public EinsteinVision_PredictionResult predictionResults{get;set;}
	public List<EinsteinVision_ApiUsage> apiUsages{get;set;}
	public static final String MODEL_GI_ID = 'GeneralImageClassifier';
	public String modelId{get;set;}
	public String errorMsg{geT;set;}
	public EinsteinVisionDemoController() {
		this.imageUrl = null;
		this.modelId = MODEL_GI_ID;
		if(ApexPages.currentPage().getParameters().get('model') != null){
			this.modelId = ApexPages.currentPage().getParameters().get('model');
		}

	}

	public static String getAccessToken(){
       	String keyContents = [Select Body From StaticResource Where Name = 'Einstein_Platform' limit 1].Body.toString();
        keyContents = keyContents.replace('-----BEGIN RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('-----END RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('\n', '');

        // Get a new token
        JWT jwt = new JWT('RS256');
        jwt.pkcs8 = keyContents;
        jwt.iss = 'developer.force.com';
        jwt.sub = 'your@email.here';
        jwt.aud = 'https://api.metamind.io/v1/oauth2/token';
        jwt.exp = '3600';
        String access_token = JWTBearerFlow.getAccessToken('https://api.metamind.io/v1/oauth2/token', jwt);
        return access_token;    
	}

	public void predict(){
		this.errorMsg = null;
		if(String.isBlank(this.imageUrl) 
			|| String.isBlank(this.imageUrl.trim())){
			this.errorMsg = 'Invalid image URL';
			return;
		}
		try{

			String token = getAccessToken();
			EinsteinVision_PredictionService service = new EinsteinVision_PredictionService(token);
		
			this.predictionResults = service.predictUrl(modelId, this.imageUrl, '');
		}catch(Exception e){
			this.errorMsg = e.getMessage();
		}
	}

}