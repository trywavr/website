import React, { ReactNode, MouseEventHandler, useState } from 'react';
import { Card, Grid } from '@components/index';
import { Beat1, Beat2, Beat3, Beat4, Beat5, Beat6 } from '@components/icons';
import { send, DemoInitialized } from '../../utils/wags/handoff';

const Drum = ({
	children,
	isActive,
	onClick,
}: {
	children: ReactNode;
	isActive: Boolean;
	onClick: MouseEventHandler<HTMLDivElement>;
}) => {
	const item = {
		hidden: {
			opacity: 0,
			x: -50,
		},
		show: {
			opacity: 1,
			x: 0,
		},
	};
	return (
		<Card
			onClick={onClick}
			toggle={isActive ? 'on' : 'off'}
			variants={item}
			initial="hidden"
			animate="show"
		>
			{children}
		</Card>
	);
};

type Beat = "BC'C1" | "BC'C2" | "BC'C3" | "BC'C4" | "BC'C5" | "BC'C6";

export const Step4 = ({
	demoInitialized,
}: {
	demoInitialized: DemoInitialized;
}) => {
	const drums: { beat: Beat; svg: JSX.Element }[] = [
		{ beat: "BC'C1", svg: Beat1 },
		{ beat: "BC'C2", svg: Beat2 },
		{ beat: "BC'C3", svg: Beat3 },
		{ beat: "BC'C4", svg: Beat4 },
		{ beat: "BC'C5", svg: Beat5 },
		{ beat: "BC'C6", svg: Beat6 },
	];
	const [selectedDrum, setSelectedDrum] = useState(drums[0]);
	const container = {
		hidden: {
			opacity: 0,
		},
		show: {
			opacity: 1,
			transition: {
				staggerChildren: 0.5,
			},
		},
	};

	return (
		<Grid
			gap="6"
			columns="2"
			variants={container}
			initial="hidden"
			animate="show"
		>
			{drums.map(drum => (
				<Drum
					key={drum.beat}
					isActive={selectedDrum.beat === drum.beat}
					onClick={() => {
						setSelectedDrum(drum);
						send(demoInitialized)({
							tag: "DE'The_possibility_to_change_a_beat",
							event: drum.beat,
						})();
					}}
				>
					{drum.svg}
				</Drum>
			))}
		</Grid>
	);
};
