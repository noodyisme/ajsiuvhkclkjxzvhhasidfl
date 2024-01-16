import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.intuit.karate.KarateOptions;
import com.intuit.karate.Results;
import com.intuit.karate.Runner;

import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;

@KarateOptions(tags = {"~@ignore"})
public class Karate {
	
	public static final ObjectMapper objectMapper = new ObjectMapper();
	public static String cucumberOutputFileName = "cucumber-report.json";
	public static String testProjectName = "masterbuilder-2-idbcore";

    @Test
    void testKarate() {
      Results results = Runner.builder().tags("~@ignore").outputCucumberJson(true).parallel(1);
      generateReport(results.getReportDir());
      assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
    public static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());

        mergeJsonsFiles(jsonFiles);

        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), testProjectName);
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }
    
    /**
	 * Merge all json files into single cucumber json 
	 * This is needed as by default framework output in separate json files
	 * 
	 * @param jsonFiles
	 */
	public static void mergeJsonsFiles(Collection<File> jsonFiles) {
		List<Object> newList = new ArrayList<>();
		try {
			// For each file , convert it to List and merge to global list
			jsonFiles.stream().map(Karate::convertoJsonList).forEach(newList::addAll);
			PrintWriter writer = new PrintWriter(cucumberOutputFileName);
			writer.write(objectMapper.writeValueAsString(newList));
			writer.close();

		} catch (FileNotFoundException | JsonProcessingException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Convert files to Json format assumer files are in array json format
	 * 
	 * @param json
	 * @return
	 */
	private static List<Object> convertoJsonList(File json) {
		List<Object> map = new ArrayList<>();
		try {
			map = objectMapper.readValue(json, new TypeReference<List<Object>>(){});
		} catch (IOException e) {
			// Silenty ignore error if not an array
		}
		return map;
	}
}
