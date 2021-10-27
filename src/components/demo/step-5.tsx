import React from 'react';
import { Checkbox, Flex, Label } from '@components/index';

const Harmony = ({ identifier }: { identifier: string }) => {
	const [checked, setChecked] = React.useState(false);
	return (
		<Flex align="center" gap={2} css={{ marginBottom: 8 }}>
			<Checkbox
				id={identifier}
				onCheckedChange={() => setChecked(true)}
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
	const vocals = ['alto', 'soprano', 'tenor', 'bass'];
	return (
		<>
			{vocals.map((vocal, index) => (
				<Harmony key={index} identifier={vocal} />
			))}
		</>
	);
};
