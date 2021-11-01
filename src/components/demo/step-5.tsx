import React from 'react';
import { Checkbox, Flex, Label } from '@components/index';
import { send, DemoInitialized } from '../../utils/wags/handoff';

const VOICE_1 = 'Voice 1';
const VOICE_2 = 'Voice 2';
const VOICE_3 = 'Voice 3';
const VOICE_4 = 'Voice 4';

const Harmony = ({
	identifier,
	demoInitialized,
}: {
	demoInitialized: DemoInitialized;
	identifier: string;
}) => {
	const [checked, setChecked] = React.useState(false);
	return (
		<Flex align="center" gap={2} css={{ marginBottom: 8 }}>
			<Checkbox
				id={identifier}
				onCheckedChange={() => {
					if (!checked) {
						send(demoInitialized)({
							tag: "DE'The_possibility_to_harmonize",
							event:
								identifier === VOICE_1
									? "H'Add_one"
									: identifier === VOICE_2
									? "H'Add_two"
									: identifier === VOICE_3
									? "H'Add_three"
									: "H'Add_four",
						})();
					}
					setChecked(true);
				}}
				disabled={checked}
			/>
			<Label htmlFor={identifier} css={{ textTransform: 'capitalize' }}>
				{identifier}
			</Label>
		</Flex>
	);
};

export const Step5 = ({
	demoInitialized,
}: {
	demoInitialized: DemoInitialized;
}) => {
	const vocals = [VOICE_1, VOICE_2, VOICE_3, VOICE_4];
	return (
		<>
			{vocals.map((vocal, index) => (
				<Harmony demoInitialized={demoInitialized} key={index} identifier={vocal} />
			))}
		</>
	);
};
