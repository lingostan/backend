import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
  CreateDateColumn,
  JoinColumn,
} from 'typeorm';
import { Lesson } from '../../lessons/entities/lesson.entity';
import { UserExerciseProgress } from '../../progress/entities/user-exercise-progress.entity';
import { Language } from '../../../language/entities/language.entity';

export enum ExerciseType {
  MULTIPLE_CHOICE = 'MULTIPLE_CHOICE',
  MULTIPLE_CHOICE_IMGS = 'MULTIPLE_CHOICE_IMGS',
  MATCHING = 'MATCHING',
  MATCHING_AUDIO = 'MATCHING_AUDIO',
  TRANSLATION = 'TRANSLATION',
  LISTENING = 'LISTENING',
  SPEAKING = 'SPEAKING',
  FILL_BLANK = 'FILL_BLANK',
  REORDER = 'REORDER',
  TRUE_FALSE = 'TRUE_FALSE',
}

@Entity()
export class Exercise {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({
    type: 'enum',
    enum: ExerciseType,
    default: ExerciseType.MULTIPLE_CHOICE,
  })
  type: ExerciseType;

  @Column()
  title: string;

  @Column({ type: 'text', nullable: true })
  instructions: string;

  @Column({ type: 'jsonb' })
  content: ExerciseContent;

  @Column({ type: 'int', default: 10 })
  points: number;

  @Column({ type: 'int', default: 1 })
  order: number;

  @Column({ type: 'jsonb', nullable: true })
  hints: string[];

  @Column({ type: 'text', nullable: true })
  explanation: string;

  @Column({ default: true })
  isActive: boolean;

  @ManyToOne(() => Lesson, (lesson) => lesson.exercises, {
    nullable: true,
    onDelete: 'SET NULL',
  })
  lesson: Lesson | null;

  @ManyToOne(() => Language, {
    nullable: true,
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'languageId' })
  language: Language | null;

  @OneToMany(() => UserExerciseProgress, (progress) => progress.exercise)
  userProgress: UserExerciseProgress[];

  @CreateDateColumn()
  createdAt: Date;

  validateAnswer(userAnswer: any): ValidationResult {
    const validator = this.getValidator();
    return validator.validate(this.content, userAnswer);
  }

  private getValidator(): ExerciseValidator {
    switch (this.type) {
      case ExerciseType.MULTIPLE_CHOICE:
        return new MultipleChoiceValidator();
      case ExerciseType.MATCHING:
        return new MatchingValidator();
      case ExerciseType.TRANSLATION:
        return new TranslationValidator();
      case ExerciseType.LISTENING:
        return new ListeningValidator();
      case ExerciseType.FILL_BLANK:
        return new FillBlankValidator();
      case ExerciseType.REORDER:
        return new ReorderValidator();
      case ExerciseType.TRUE_FALSE:
        return new TrueFalseValidator();
      default:
        throw new Error(`Unsupported exercise type: ${this.type}`);
    }
  }
}

// ========== CONTENT INTERFACES ==========
export type ExerciseContent =
  | MultipleChoiceContent
  | MatchingContent
  | TranslationContent
  | ListeningContent
  | FillBlankContent
  | ReorderContent
  | TrueFalseContent;

export interface MultipleChoiceContent {
  question: string;
  audioUrl?: string;
  imageUrl?: string;
  options: {
    id: string;
    text: string;
    correct: boolean;
  }[];
}

export interface MatchingContent {
  pairs: {
    id: string;
    left: string;
    right: string;
    leftImage?: string;
    rightImage?: string;
  }[];
  shuffled?: boolean;
}

export interface TranslationContent {
  sourceText: string;
  targetLanguage: string;
  acceptedAnswers: string[];
  strictMode: boolean;
  hints?: string[];
}

export interface ListeningContent {
  audioUrl: string;
  question: string;
  exerciseType: 'MULTIPLE_CHOICE' | 'TRANSCRIPTION' | 'COMPREHENSION';
  options?: {
    id: string;
    text: string;
    correct: boolean;
  }[];
  correctAnswer?: string;
  acceptedAnswers?: string[];
  transcription?: string;
  strictMode?: boolean;
}

export interface FillBlankContent {
  text: string;
  blanks: {
    position: number;
    correctAnswer: string;
    acceptedAnswers?: string[];
    hints?: string[];
  }[];
}

export interface ReorderContent {
  items: string[];
  correctOrder: number[];
}

export interface TrueFalseContent {
  statement: string;
  correct: boolean;
  explanation?: string;
}

// ========== VALIDATION ==========
export interface ValidationResult {
  correct: boolean;
  score: number;
  maxScore: number;
  feedback: string;
  correctAnswer?: any;
}

interface ExerciseValidator {
  validate(content: ExerciseContent, userAnswer: any): ValidationResult;
}

class MultipleChoiceValidator implements ExerciseValidator {
  validate(
    content: MultipleChoiceContent,
    userAnswer: { selectedOptionId: string },
  ): ValidationResult {
    const correctOption = content.options.find((opt) => opt.correct);
    const isCorrect =
      correctOption && userAnswer.selectedOptionId === correctOption.id;

    return {
      correct: isCorrect,
      score: isCorrect ? 10 : 0,
      maxScore: 10,
      feedback: isCorrect
        ? 'Correct!'
        : `The correct answer was: ${correctOption?.text}`,
      correctAnswer: correctOption,
    };
  }
}

class MatchingValidator implements ExerciseValidator {
  validate(
    content: MatchingContent,
    userAnswer: { pairs: { id: string; matchedWith: string }[] },
  ): ValidationResult {
    let correctCount = 0;
    const totalPairs = content.pairs.length;

    for (const userPair of userAnswer.pairs) {
      const correctPair = content.pairs.find((p) => p.id === userPair.id);
      if (correctPair && userPair.matchedWith === correctPair.right) {
        correctCount++;
      }
    }

    const isPerfect = correctCount === totalPairs;
    const score = Math.round((correctCount / totalPairs) * 10);

    return {
      correct: isPerfect,
      score,
      maxScore: 10,
      feedback: isPerfect
        ? 'Perfect! All matches correct.'
        : `You got ${correctCount} out of ${totalPairs} correct.`,
      correctAnswer: content.pairs,
    };
  }
}

class TranslationValidator implements ExerciseValidator {
  validate(
    content: TranslationContent,
    userAnswer: { translation: string },
  ): ValidationResult {
    const userText = userAnswer.translation.toLowerCase().trim();
    const isCorrect = content.acceptedAnswers.some(
      (answer) => this.normalizeText(userText) === this.normalizeText(answer),
    );

    if (content.strictMode) {
      const exactMatch = content.acceptedAnswers.some(
        (answer) => userText === answer.toLowerCase(),
      );

      return {
        correct: exactMatch,
        score: exactMatch ? 10 : 0,
        maxScore: 10,
        feedback: exactMatch
          ? 'Perfect translation!'
          : `Expected: ${content.acceptedAnswers[0]}`,
        correctAnswer: content.acceptedAnswers[0],
      };
    }

    return {
      correct: isCorrect,
      score: isCorrect ? 10 : 0,
      maxScore: 10,
      feedback: isCorrect
        ? 'Good job!'
        : `Expected something like: ${content.acceptedAnswers[0]}`,
      correctAnswer: content.acceptedAnswers[0],
    };
  }

  private normalizeText(text: string): string {
    return text
      .toLowerCase()
      .replace(/[^\w\s]/g, '')
      .trim();
  }
}

class ListeningValidator implements ExerciseValidator {
  validate(content: ListeningContent, userAnswer: any): ValidationResult {
    switch (content.exerciseType) {
      case 'MULTIPLE_CHOICE':
        return this.validateMultipleChoice(content, userAnswer);
      case 'TRANSCRIPTION':
        return this.validateTranscription(content, userAnswer);
      case 'COMPREHENSION':
        return this.validateComprehension(content, userAnswer);
      default:
        throw new Error('Unsupported listening exercise type');
    }
  }

  private validateMultipleChoice(
    content: ListeningContent,
    userAnswer: { selectedOptionId: string },
  ): ValidationResult {
    const correctOption = content.options.find((opt) => opt.correct);
    const isCorrect =
      correctOption && userAnswer.selectedOptionId === correctOption.id;

    return {
      correct: isCorrect,
      score: isCorrect ? 10 : 0,
      maxScore: 10,
      feedback: isCorrect
        ? 'Correct!'
        : `The correct answer was: ${correctOption?.text}`,
      correctAnswer: correctOption,
    };
  }

  private validateTranscription(
    content: ListeningContent,
    userAnswer: { transcription: string },
  ): ValidationResult {
    const userText = userAnswer.transcription.toLowerCase().trim();
    const correctText = content.correctAnswer.toLowerCase().trim();

    if (content.strictMode) {
      const isCorrect = userText === correctText;
      return {
        correct: isCorrect,
        score: isCorrect ? 10 : 0,
        maxScore: 10,
        feedback: isCorrect
          ? 'Perfect transcription!'
          : `Expected: ${content.correctAnswer}`,
        correctAnswer: content.correctAnswer,
      };
    }

    const similarity = this.calculateSimilarity(userText, correctText);
    const isCorrect = similarity > 0.8;
    const score = Math.round(similarity * 10);

    return {
      correct: isCorrect,
      score,
      maxScore: 10,
      feedback: isCorrect ? 'Good job!' : `Expected: ${content.correctAnswer}`,
      correctAnswer: content.correctAnswer,
    };
  }

  private validateComprehension(
    content: ListeningContent,
    userAnswer: { answer: string },
  ): ValidationResult {
    const userText = userAnswer.answer.toLowerCase().trim();
    const acceptedAnswers = content.acceptedAnswers.map((a) => a.toLowerCase());
    const isCorrect = acceptedAnswers.some(
      (answer) => userText.includes(answer) || answer.includes(userText),
    );

    return {
      correct: isCorrect,
      score: isCorrect ? 10 : 0,
      maxScore: 10,
      feedback: isCorrect
        ? 'Correct!'
        : `The answer was: ${content.correctAnswer}`,
      correctAnswer: content.correctAnswer,
    };
  }

  private calculateSimilarity(text1: string, text2: string): number {
    const words1 = new Set(text1.split(/\s+/));
    const words2 = new Set(text2.split(/\s+/));

    const intersection = new Set([...words1].filter((x) => words2.has(x)));
    const union = new Set([...words1, ...words2]);

    return intersection.size / union.size;
  }
}

class FillBlankValidator implements ExerciseValidator {
  validate(
    content: FillBlankContent,
    userAnswer: { answers: { [key: number]: string } },
  ): ValidationResult {
    let correctCount = 0;
    const totalBlanks = content.blanks.length;

    for (const blank of content.blanks) {
      const userAnswerText = userAnswer.answers[blank.position]
        ?.toLowerCase()
        .trim();
      const correctAnswers = [
        blank.correctAnswer,
        ...(blank.acceptedAnswers || []),
      ].map((a) => a.toLowerCase());

      if (
        userAnswerText &&
        correctAnswers.some(
          (correct) =>
            this.normalizeText(userAnswerText) === this.normalizeText(correct),
        )
      ) {
        correctCount++;
      }
    }

    const score = Math.round((correctCount / totalBlanks) * 10);
    const isPerfect = correctCount === totalBlanks;

    return {
      correct: isPerfect,
      score,
      maxScore: 10,
      feedback: isPerfect
        ? 'Perfect! All blanks filled correctly.'
        : `You got ${correctCount} out of ${totalBlanks} correct.`,
      correctAnswer: content.blanks.reduce((acc, blank) => {
        acc[blank.position] = blank.correctAnswer;
        return acc;
      }, {}),
    };
  }

  private normalizeText(text: string): string {
    return text
      .toLowerCase()
      .replace(/[^\w\s]/g, '')
      .trim();
  }
}

class ReorderValidator implements ExerciseValidator {
  validate(
    content: ReorderContent,
    userAnswer: { order: number[] },
  ): ValidationResult {
    let correctCount = 0;
    const totalItems = content.correctOrder.length;

    for (let i = 0; i < totalItems; i++) {
      if (userAnswer.order[i] === content.correctOrder[i]) {
        correctCount++;
      }
    }

    const score = Math.round((correctCount / totalItems) * 10);
    const isPerfect = correctCount === totalItems;

    return {
      correct: isPerfect,
      score,
      maxScore: 10,
      feedback: isPerfect
        ? 'Perfect order!'
        : `You got ${correctCount} out of ${totalItems} in correct position.`,
      correctAnswer: content.correctOrder,
    };
  }
}

class TrueFalseValidator implements ExerciseValidator {
  validate(
    content: TrueFalseContent,
    userAnswer: { answer: boolean },
  ): ValidationResult {
    const isCorrect = userAnswer.answer === content.correct;

    return {
      correct: isCorrect,
      score: isCorrect ? 10 : 0,
      maxScore: 10,
      feedback: isCorrect
        ? 'Correct!'
        : `The statement is ${content.correct ? 'true' : 'false'}. ${content.explanation || ''}`,
      correctAnswer: content.correct,
    };
  }
}
