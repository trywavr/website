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
					<link
						rel="apple-touch-icon"
						sizes="180x180"
						href="/public/apple-touch-icon.png"
					/>
					<link
						rel="icon"
						type="image/png"
						sizes="32x32"
						href="/public/favicon-32x32.png"
					/>
					<link
						rel="icon"
						type="image/png"
						sizes="16x16"
						href="/public/favicon-16x16.png"
					/>
					<link
						rel="mask-icon"
						href="/public/safari-pinned-tab.svg"
						color="#4345F8"
					/>
					<meta name="msapplication-TileColor" content="#4345F8" />
					<meta name="theme-color" content="#ffffff" />
					<link rel="manifest" href="/manifest.json" />
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
