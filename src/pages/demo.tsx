import React, { useEffect, useState } from 'react';
import { styled } from '@stitches/react';
import { useRouter } from 'next/router';
import { Step0 } from '../components/demo/step-0';
import { Button } from '../components/button';
import { AnimatedHeading } from '../components/demo/animated-heading';

const Container = styled('div', {
  marginTop: '40px',
  height: "84vh",
  display: 'flex',
  flexDirection: 'column',
});

const Demo = () => {
  const router = useRouter();
  const { stepNumber } = router.query;
  const stepQueryParams =
    stepNumber && typeof stepNumber === 'string'
      ? parseInt(stepNumber)
      : undefined;
  const [step, setStep] = useState<number>(stepQueryParams || 0);

  useEffect(() => {
    setStep(stepQueryParams || 0);
  }, [stepNumber])

  return (
    <Container>
      {step === 0 && (
        <>
          <AnimatedHeading text="Peek into what's possible" />
          <Step0 />
        </>
      )}
      {step === 1 && (
        <>
          <AnimatedHeading text="Hello" />
        </>
      )}

      <div style={{ display: 'flex', justifyContent: 'flex-end', alignSelf: 'flex-end' }}>
        <Button
          size={2}
          onClick={() => {
            router.push(`/demo?stepNumber=${step + 1}`);
          }}
        >
          Next
        </Button>
      </div>
    </Container>
  );
};

export default Demo;
