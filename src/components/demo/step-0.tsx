import React, { Dispatch, SetStateAction } from 'react';
import Image from 'next/image';
import { styled } from '@stitches/react';
import { Text } from '@components/index';
import { PlayIcon } from '@radix-ui/react-icons';

const Box = styled('div', {
	borderRadius: '$2',
	padding: '$4',
	border: '1px solid $mauve6',
	display: 'flex',
	alignItems: 'center',
	justifyContent: 'space-between',
});

export const Step0 = ({
	setStep,
	onClick
}: {
	setStep: Dispatch<SetStateAction<number>>;
	onClick: () => void;
}) => {
	return (
		<>
			<Box onClick={() => {onClick(); setStep(1)}}>
				<div style={{ display: 'flex', alignItems: 'center' }}>
					<div
						style={{
							position: 'relative',
							height: 40,
							width: 40,
							borderRadius: 6,
							marginRight: 16,
							overflow: 'hidden',
						}}
					>
						<Image
							alt="Prince Kiss album art"
							src="https://upload.wikimedia.org/wikipedia/en/d/d8/Prince_kiss.jpg"
							layout="fill"
							objectFit="cover"
						/>
					</div>
					<div
						style={{
							height: '100%',
							display: 'flex',
							flexDirection: 'column',
							justifyContent: 'space-between',
						}}
					>
						<Text size="lg" fontWeight={700} color="primary">
							Kiss
						</Text>
						<Text size="md" fontWeight={400}>
							Prince
						</Text>
					</div>
				</div>
				<PlayIcon />
			</Box>
		</>
	);
};
