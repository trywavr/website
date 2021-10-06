import Document, { Html, Head, Main, NextScript } from 'next/document';
import { getCssText, globalStyles } from '../../stitches.config';

class MyDocument extends Document {
	render() {
		globalStyles();
		return (
			<Html lang="en">
				<Head>
					{/* Import fonts Inter, JetBrains mono and Darker Grotesque */}
					<link
						href="https://fonts.googleapis.com/css2?family=Inter&display=optional"
						rel="stylesheet"
					/>
					<link
						href="https://fonts.googleapis.com/css2?family=JetBrains+Mono&display=optional"
						rel="stylesheet"
					/>
					<link
						href="https://fonts.googleapis.com/css2?family=Darker+Grotesque&display=optional"
						rel="stylesheet"
					/>
					{/* Stitches setup */}
					<style
						id="stitches"
						dangerouslySetInnerHTML={{ __html: getCssText() }}
					/>
					{/* Page setup */}
					<meta
						name="viewport"
						content="width=device-width, initial-scale=1.0"
					/>
					<link rel="icon" href="/favicon.ico" />
					<title>wavr | music reimagined.</title>
					<meta
						name="description"
						content="Dynamic audio experiences for creators and listeners."
					/>
				</Head>
				<body style={{ margin: 0 }}>
					<Main />
					<NextScript />
				</body>
			</Html>
		);
	}
}

export default MyDocument;
