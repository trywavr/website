import React from 'react';
import type { AppProps } from 'next/app';
import { IdProvider } from '@radix-ui/react-id';
import { styled } from '@stitches/react';
import { Navigation } from '../components/navigation';
import { ThemeProvider } from 'next-themes';
import { darkTheme } from '../../stitches.config';
import Head from 'next/head';

const MainContainer = styled('main', {
	minHeight: '90vh',
	padding: '1rem',
});

function MyApp({ Component, pageProps }: AppProps) {
	return (
		<IdProvider>
			<ThemeProvider
				disableTransitionOnChange
				attribute="class"
				value={{ light: 'light-theme', dark: darkTheme.className }}
				defaultTheme="system"
			>
				<Head>
					<meta charSet="utf-8" />
					<meta
						name="viewport"
						content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no"
					/>
					<link rel="manifest" href="/manifest.json" />
					<meta name="theme-color" content="#4345F8" />

					<link
						href="/icons/favicon-16x16.png"
						rel="icon"
						type="image/png"
						sizes="16x16"
					/>
					<link
						href="/icons/favicon-32x32.png"
						rel="icon"
						type="image/png"
						sizes="32x32"
					/>
					<link
						rel="apple-touch-icon"
						sizes="180x180"
						href="/icons/apple-touch-icon.png"
					/>
					<link
						rel="mask-icon"
						href="/icons/safari-pinned-tab.svg"
						color="#4345F8"
					/>

					<title>wavr | music reimagined.</title>
					<meta
						name="description"
						content="Dynamic audio experiences for creators and listeners."
					/>
				</Head>
				<MainContainer>
					<Navigation />
					<Component {...pageProps} />
				</MainContainer>
			</ThemeProvider>
		</IdProvider>
	);
}
export default MyApp;
