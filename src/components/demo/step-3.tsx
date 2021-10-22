import React from 'react';
import { Checkbox, Radio, RadioGroup, Slider } from '@components/index';

type Step3State = {
	checked: boolean;
	choice: "NDC'C1" | "NDC'C2" | "NDC'C3";
	slider: number;
};
const SLIDER_MAX = 50.0;

export const Step3 = ({
	demoInitialized,
}: {
	demoInitialized: DemoInitialized;
}) => {
	const [step3State, setStep3State] = React.useState({
		check: false,
		choice: "NDC'C1",
		slider: 0.0,
	});
	return (
		<>
			<Slider
				onValueChange={e => {
					setStep3State({ ...step3State, slider: e[0] / SLIDER_MAX });
				}}
				defaultValue={[10]}
				max={SLIDER_MAX}
			/>
			<div
				style={{
					display: 'flex',
					flexDirection: 'row',
					gap: 16,
					margin: '16px 0',
				}}
			>
				<Checkbox size="2" />
				<Checkbox size="2" />
				<Checkbox size="2" />
			</div>
			<RadioGroup defaultValue="happy">
				<Radio value="hello" size="2" />
				<Radio value="happy" size="2" />
				<Radio value="halloween" size="2" />
			</RadioGroup>
		</>
	);
};
