import React from 'react';
import type { NextPage } from 'next';
import { styled } from '@stitches/react';
import { Text } from '../components/text';
import { TwitterLogoIcon, GitHubLogoIcon } from '@radix-ui/react-icons';
import { IconButton } from '../components/icon-button';

const Container = styled('div', {
	display: 'flex',
	flexDirection: 'column',
	height: '100%',
	maxWidth: '800px',
	margin: '0 auto',
	padding: '128px 0',
});

const H1 = styled('h1', {
	margin: '0 0 20px 0',
	fontFamily: '$grotesque',
	fontSize: '$5xl',
	fontWeight: '$700',
});

const Home: NextPage = () => {
	return (
		<Container>
			<H1>Dynamic audio experiences for creators and listeners.</H1>
			<Text style={{ maxWidth: 650, lineHeight: 1.6, marginBottom: 20 }}>
				The pinnacle of a musical experience is the dynamism of a live
				performance. Why are we still limiting our daily music consumption to
				static files?
			</Text>
			<div style={{ display: 'flex' }}>
				<IconButton
					size="3"
					as="a"
					target="_blank"
					rel="noopener"
					href="https://twitter.com/trywavr"
					style={{ marginRight: 8 }}
				>
					<TwitterLogoIcon />
				</IconButton>
				<IconButton
					size="3"
					as="a"
					target="_blank"
					rel="noopener"
					href="https://github.com/trywavr"
				>
					<GitHubLogoIcon />
				</IconButton>
			</div>
		</Container>
	);
};

export default Home;
