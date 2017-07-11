public with sharing class EinsteinVisionDemoAdminController {
	public EinsteinVisionDemoAdminController() {
		this.datasetId = null;
	}

	public String modelId{get;set;}
	public String datasetUrl{get;set;}
	public Long datasetId{get;set;}
	public String debug{get;set;}


	public void getDatasetsAndModels(){
		String token = EinsteinVisionDemoController.getAccessToken();
		EinsteinVision_PredictionService service = new EinsteinVision_PredictionService(token);
		List<EinsteinVision_Dataset> datasets = service.getDatasets();
		debug = 'Datasets: '+datasets.size();
		for (EinsteinVision_Dataset dataset : datasets) {
			debug +='\n\n'+ JSON.serializePretty(dataset);
		    List<EinsteinVision_Model> models = service.getModels(dataset);
		    if(models != null){
			    for (EinsteinVision_Model model : models) {
			        EinsteinVision_ModelMetrics metrics = service.getModelMetrics(model.modelId);
			        debug +='\n\n'+ JSON.serializePretty(model);
			    }
			}
		}
	}

	public void createModelAsync(){
		String token = EinsteinVisionDemoController.getAccessToken();
		if(String.isBlank(datasetUrl)){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Dataset ZIP url'));
			return;
		}
		EinsteinVision_PredictionService service = new EinsteinVision_PredictionService(token);
		EinsteinVision_Dataset dataset = service.createDatasetFromUrlAsync(datasetUrl);
		debug = 'DATASET:\n\n'+JSON.serializePretty(dataset);

	}

	public void trainModel(){
		String token = EinsteinVisionDemoController.getAccessToken();
		EinsteinVision_PredictionService service = new EinsteinVision_PredictionService(token);

		if(datasetId == null
			|| datasetId == 0){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Dataset ID'));
			return;
		}

		EinsteinVision_Model model = service.trainDataset(this.datasetId, 'My Model '+System.today(), 3, 0.01, null);
		debug += 'MODEL:\n\n'+JSON.serializePretty(model);
	}

	public void getApiUsage(){
		String token = EinsteinVisionDemoController.getAccessToken();
		EinsteinVision_PredictionService service = new EinsteinVision_PredictionService(token);

		List<EinsteinVision_ApiUsage> usages = service.getApiUsage();
		debug = 'API USAGE:\n\n'+JSON.serializePretty(usages);
	}

	public void deleteDataset(){
		String token = EinsteinVisionDemoController.getAccessToken();
		EinsteinVision_PredictionService service = new EinsteinVision_PredictionService(token);

		if(datasetId == null
			|| datasetId == 0){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Dataset ID'));
			return;
		}

		Boolean result = service.deleteDataset(datasetId);
		debug = 'Deletion result: '+result;
	}
}