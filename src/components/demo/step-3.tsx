import React from 'react';
import { Checkbox, Radio, RadioGroup, Slider } from '@components/index';
// @ts-expect-error TODO fix types
import { send } from '../../utils/wags/handoff';

type Step3State = {
	check: boolean;
	choice: "NDC'C1" | "NDC'C2" | "NDC'C3";
	slider: number;
};
const SLIDER_MAX = 50.0;

export const Step3 = ({
	demoInitialized,
}: {
	demoInitialized: DemoInitialized;
}) => {
	const [step3State, setStep3State] = React.useState<Step3State>({
		check: false,
		choice: "NDC'C1",
		slider: 0.0,
	});
	const updateState = (s: Step3State) => {
		setStep3State(s);
		send(demoInitialized)({
			tag: "DE'The_possibility_to_take_a_sound_in_a_new_direction",
			event: s,
		})();
	};
	return (
		<>
			<Slider
				onValueChange={e => {
					updateState({ ...step3State, slider: e[0] / SLIDER_MAX });
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
				<Checkbox
					onCheckedChange={e =>
						updateState({
							...step3State,
							check: typeof e === 'boolean' ? e : false,
						})
					}
					size="2"
				/>
				<Checkbox size="2" />
				<Checkbox size="2" />
			</div>
			<RadioGroup
				onValueChange={v =>
					updateState({
						...step3State,
						choice:
							v === 'hello' ? "NDC'C1" : v === 'happy' ? "NDC'C2" : "NDC'C3",
					})
				}
				defaultValue="happy"
			>
				<Radio value="hello" size="2" />
				<Radio value="happy" size="2" />
				<Radio value="halloween" size="2" />
			</RadioGroup>
		</>
	);
};
