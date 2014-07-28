package fr.univmobile.it;

import java.io.File;
import java.io.IOException;

import javax.annotation.Nullable;

import org.apache.tools.ant.DefaultLogger;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.ProjectHelper;

public abstract class AntUtils {

	public static void executeTarget(final String target) throws IOException {

		final File buildFile = new File("build.xml");

		System.out.println("Running Ant file: " //
				+ buildFile.getCanonicalPath() + "...");

		final Project project = new Project();

		ProjectHelper.configureProject(project, buildFile);

		final DefaultLogger consoleLogger = new DefaultLogger();

		consoleLogger.setErrorPrintStream(System.err);
		consoleLogger.setOutputPrintStream(System.out);
		consoleLogger.setMessageOutputLevel(Project.MSG_INFO);

		project.addBuildListener(consoleLogger);

		@Nullable
		final String requiredAppCommitId = System.getProperty("appCommitId");

		if (requiredAppCommitId != null) {

			project.setProperty("appCommitId", requiredAppCommitId);
		}

		project.init();

		project.executeTarget(target);
	}
}
