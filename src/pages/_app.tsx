import React from 'react';
import type { AppProps } from 'next/app';
import { IdProvider } from '@radix-ui/react-id';
import { styled } from '@stitches/react';
import { Navigation } from '../components/navigation';
import { ThemeProvider } from 'next-themes';
import { darkTheme } from '../../stitches.config';

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
				<MainContainer>
					<Navigation />
					<Component {...pageProps} />
				</MainContainer>
			</ThemeProvider>
		</IdProvider>
	);
}
export default MyApp;
