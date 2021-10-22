import React from 'react';
import { SpeakerLoudIcon, SpeakerOffIcon } from '@radix-ui/react-icons';
import { Text } from '../text';
import { styled } from '@stitches/react';
import { motion } from 'framer-motion';
import { send } from '../../utils/wags/handoff';

const instruments = ['Happiness', 'Sadness', 'Confusion', 'Regret'];

const InstrumentCard = styled(motion.li, {
	display: 'flex',
	alignItems: 'center',
	justifyContent: 'space-between',
	borderRadius: '$2',
	padding: '$4',
	marginBottom: '16px',
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

const Instrument = ({
	instrument,
	demoInitialized,
	toggle,
	setToggle,
}: {
	instrument: string;
	demoInitialized: DemoInitialized;
	toggle: Toggles;
	setToggle: React.Dispatch<React.SetStateAction<Toggles>>;
}) => {
	const listItem = {
		hidden: { opacity: 0, x: -50 },
		show: { opacity: 1, x: 0 },
	};
	const toggleCondition =
		instrument === 'Happiness'
			? toggle.one
			: instrument === 'Sadness'
			? toggle.two
			: instrument === 'Confusion'
			? toggle.three
			: instrument === 'Regret'
			? toggle.four
			: false;
	return (
		<InstrumentCard
			onClick={() => {
				const newToggle = {
					one: instrument === 'Happiness' ? !toggle.one : toggle.one,
					two: instrument === 'Sadness' ? !toggle.two : toggle.two,
					three: instrument === 'Confusion' ? !toggle.three : toggle.three,
					four: instrument === 'Regret' ? !toggle.four : toggle.four,
				}
				send(demoInitialized)({
					tag: "DE'The_possibility_to_add_new_sounds",
					event: newToggle,
				})();
				setToggle(newToggle);
			}}
			toggle={toggleCondition ? 'on' : 'off'}
			variants={listItem}
		>
			<Text color="inherit">{instrument}</Text>
			{toggleCondition ? <SpeakerLoudIcon /> : <SpeakerOffIcon />}
		</InstrumentCard>
	);
};
type Toggles = {
	one: boolean;
	two: boolean;
	three: boolean;
	four: boolean;
};

export const Step2 = ({
	demoInitialized,
}: {
	demoInitialized: DemoInitialized;
}) => {
	const container = {
		hidden: { opacity: 0 },
		show: {
			opacity: 1,
			transition: {
				staggerChildren: 0.5,
			},
		},
	};
	const [toggle, setToggle] = React.useState({
		one: true,
		two: false,
		three: false,
		four: false,
	});

	return (
		<motion.ul
			style={{ padding: 0 }}
			variants={container}
			initial="hidden"
			animate="show"
		>
			{instruments.map(instrument => (
				<Instrument
					demoInitialized={demoInitialized}
					key={instrument}
					toggle={toggle}
					setToggle={setToggle}
					instrument={instrument}
				/>
			))}
		</motion.ul>
	);
};
