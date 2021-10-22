import React, { ReactNode, MouseEventHandler, useState } from 'react';
import { Grid } from '@components/index';
import { styled } from '@stitches/react';
import {
	Beat1,
	Beat2,
	Beat3,
	Beat4,
	Beat5,
	Beat6,
	Beat7,
	Beat8,
} from '@components/icons';

const StyledDrum = styled('div', {
	display: 'flex',
	alignItems: 'center',
	justifyContent: 'flex-start',
	height: 64,
	width: '100%',
	borderRadius: '$2',
	variants: {
		toggle: {
			on: {
				border: '1px solid $mauve9',
				color: '$mauve12',
				boxShadow: '0 0 16px 0 $colors$violetA9',
			},
			off: {
				border: '1px solid $mauve6',
				color: '$mauve11',
			},
		},
	},
	defaultVariants: {
		toggle: 'off',
	},
});

const Drum = ({
	children,
	isActive,
	onClick,
}: {
	children: ReactNode;
	isActive: Boolean;
	onClick: MouseEventHandler<HTMLDivElement>;
}) => {
	return (
		<StyledDrum onClick={onClick} toggle={isActive ? 'on' : 'off'}>
			{children}
		</StyledDrum>
	);
};

export const Step4 = () => {
	const drums: {beat: number, svg: JSX.Element}[] = [
		{ beat: 1, svg: Beat1 },
		{ beat: 2, svg: Beat2 },
		{ beat: 3, svg: Beat3 },
		{ beat: 4, svg: Beat4 },
		{ beat: 5, svg: Beat5 },
		{ beat: 6, svg: Beat6 },
		{ beat: 7, svg: Beat7 },
		{ beat: 8, svg: Beat8 },
	];
	const [selectedDrum, setSelectedDrum] = useState(drums[0]);
	return (
		<Grid gap="6" columns="2">
			{drums.map(drum => (
				<Drum
					isActive={selectedDrum.beat === drum.beat}
					onClick={() => setSelectedDrum(drum)}
				>
					{drum.svg}
				</Drum>
			))}
		</Grid>
	);
};
